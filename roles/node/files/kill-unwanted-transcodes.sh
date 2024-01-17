#!/bin/bash

# indicates something being transcoded from hevc to h264
ps aux | grep Plex | grep "hevc" | grep "libx264" |grep -v grep|awk '{print $2}' | xargs --no-run-if-empty kill -9

# indicates hevc being transcoded to x264 using gpu (inefficient)
ps aux | grep Plex | grep "hevc" | grep "h264_vaapi" |grep -v grep|awk '{print $2}' | xargs --no-run-if-empty kill -9

# kill ANY hevc (almost all 4k) transcodes excluding audio only
ps aux | grep Plex | grep "codec" | grep "hevc" | grep -v grep | grep -v eae |awk '{print $2}' | xargs --no-run-if-empty kill -9

# kill ANY video transcodes not using the GPU (i.e., non-plexpass users), excluding audio
ps aux | grep Plex | grep -- -codec | grep -v grep | grep -v vaapi | grep -v eae | awk '{print $2}' | xargs --no-run-if-empty kill -9

# Kill ANY transcodes of 4K content whatsover, if we can tell based on the filename
ps aux | grep Plex | grep "codec:v" | grep "h264" | grep -v grep| grep -E "2160p|4K" | awk '{print $2}' | xargs --no-run-if-empty kill -9

# # kill h264 ffmpeg transcodes not using the GPU (i.e., unconfigured jellyfin users)
# ps aux | grep ffmpeg | grep "codec:v" | grep "h264" | grep -v grep | grep -v vaapi | awk '{print $2}' | xargs --no-run-if-empty kill -9
