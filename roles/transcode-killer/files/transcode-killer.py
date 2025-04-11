#!/usr/bin/env python3
import os
import time
import signal
import re
import subprocess
from datetime import datetime

CHECK_INTERVAL = 5  # seconds
LOG_FILE = "/var/log/transcode-killer.log"

# Add your regex-based exceptions here (e.g., allow audio-only transcodes)
EXCEPTIONS = [
    r"-codec:1\s+copy",  # audio is not being transcoded
]

def log(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"{timestamp} {message}\n")

def get_matching_processes():
    try:
        result = subprocess.run(["ps", "axo", "pid=,comm=,args="], capture_output=True, text=True, check=True)
        for line in result.stdout.strip().splitlines():
            try:
                pid_str, command, cmdline = re.split(r'\s+', line.strip(), maxsplit=2)
                pid = int(pid_str)
                if "ffmpeg" in command.lower() or "plex transcoder" in cmdline.lower():
                    yield pid, command, cmdline
            except ValueError:
                continue
    except Exception as e:
        log(f"Error reading processes: {e}")

def is_exception(cmdline):
    return any(re.search(pattern, cmdline) for pattern in EXCEPTIONS)

def is_video_transcode(cmdline):
    """
    Return (True, reason) if a video transcode or subtitle extraction should be killed.
    """
    # Check for subtitle extraction (both -an and -vn flags present)
    if "-an" in cmdline and "-vn" in cmdline:
        return True, "Subtitle extraction detected (-an and -vn flags)"

    # Check for audio-only transcodes (no video codec or video mapping)
    if not re.search(r'-(?:c:v|codec:0|map\s+0:v)', cmdline) and re.search(r'-(?:ac|ar|acodec)', cmdline):
        return False, None  # Allow audio-only transcodes

    # Find the final video codec
    video_codec_match = re.findall(r'-(?:c:v|codec:0)\s+(\S+)', cmdline)
    video_codec = video_codec_match[-1].lower() if video_codec_match else None

    # Allow copying/remuxing
    if video_codec == "copy":
        return False, None

    # Check if VA-API is mentioned for hardware transcoding
    if "vaapi" not in cmdline.lower():
        return True, "No VA-API involved, blocking software transcode"

    # Detect input resolution (to block transcoding from 4K)
    input_match = re.search(r'-i\s+(\S+)', cmdline)
    if input_match:
        input_path = input_match.group(1)
        if re.search(r'4k|2160', input_path, re.IGNORECASE):
            return True, f"Transcoding from 4K source ({input_path}) is not allowed"

    return False, None

def monitor():
    while True:
        for pid, command, cmdline in get_matching_processes():
            should_kill, reason = is_video_transcode(cmdline)
            if should_kill and not is_exception(cmdline):
                try:
                    os.kill(pid, signal.SIGKILL)
                    log(f"KILLED PID {pid} ({command}) - {reason} - {cmdline}")
                except ProcessLookupError:
                    continue
                except PermissionError:
                    log(f"Permission denied trying to kill PID {pid}")
        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    monitor()
