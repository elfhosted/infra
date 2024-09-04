#!/usr/bin/env bash
# Script informed by the collectd monitoring script for smartmontools (using smartctl)
# by Samuel B. <samuel_._behan_(at)_dob_._sk> (c) 2012
# source at: http://devel.dob.sk/collectd-scripts/

# TODO: This probably needs to be a little more complex.  The raw numbers can have more
#       data in them than you'd think.
#       http://arstechnica.com/civis/viewtopic.php?p=22062211

# Formatting done via shfmt -i 2
# https://github.com/mvdan/sh

SMARTCTL=/usr/sbin/smartctl
#FORCED_DEVICE_LIST=$(cat << EOF
#/dev/sg3|scsi
#/dev/sg4|sat
#/dev/sg5|sat
#/dev/sg6|sat
#/dev/sg7|scsi
#/dev/sg8|sat
#/dev/sg9|sat
#/dev/sdc|sat
#EOF
#)

parse_smartctl_attributes_awk="$(
  cat <<'SMARTCTLAWK'
$1 ~ /^ *[0-9]+$/ && $2 ~ /^[a-zA-Z0-9_-]+$/ {
  gsub(/-/, "_");
  printf "%s_value{%s,smart_id=\"%s\"} %d\n", tolower($2), labels, $1, $4
  printf "%s_worst{%s,smart_id=\"%s\"} %d\n", tolower($2), labels, $1, $5
  printf "%s_threshold{%s,smart_id=\"%s\"} %d\n", tolower($2), labels, $1, $6
  printf "%s_raw_value{%s,smart_id=\"%s\"} %e\n", tolower($2), labels, $1, $10
}
SMARTCTLAWK
)"

smartmon_attrs="$(
  cat <<'SMARTMONATTRS'
airflow_temperature_cel
command_timeout
current_pending_sector
end_to_end_error
erase_fail_count
g_sense_error_rate
hardware_ecc_recovered
host_reads_mib
host_reads_32mib
host_writes_mib
host_writes_32mib
load_cycle_count
media_wearout_indicator
multi_zone_error_rate
wear_leveling_count
nand_writes_1gib
offline_uncorrectable
percent_lifetime_remain
power_cycle_count
power_off_retract_count
power_on_hours
program_fail_count
raw_read_error_rate
reallocated_event_count
reallocated_sector_ct
reallocate_nand_blk_cnt
reported_uncorrect
sata_downshift_count
seek_error_rate
spin_retry_count
spin_up_time
start_stop_count
temperature_case
temperature_celsius
temperature_internal
total_lbas_read
total_lbas_written
total_host_sector_write
udma_crc_error_count
unsafe_shutdown_count
workld_host_reads_perc
workld_media_wear_indic
workload_minutes
SMARTMONATTRS
)"
smartmon_attrs="$(echo ${smartmon_attrs} | xargs | tr ' ' '|')"

parse_smartctl_attributes() {
  local disk="$1"
  local disk_type="$2"
  local name="$3"
  local labels="disk=\"${disk}\",type=\"${disk_type}\",name=\"${name}\""
  local vars="$(echo "${smartmon_attrs}" | xargs | tr ' ' '|')"
  sed 's/^ \+//g' |
    awk -v labels="${labels}" "${parse_smartctl_attributes_awk}" 2>/dev/null |
    grep -E "(${smartmon_attrs})"
}

parse_smartctl_scsi_attributes() {
  local disk="$1"
  local disk_type="$2"
  local name="$3"
  local labels="disk=\"${disk}\",type=\"${disk_type}\",name=\"${name}\""
  while read line; do
    attr_type="$(echo "${line}" | tr '=' ':' | cut -f1 -d: | sed 's/^ \+//g' | tr ' ' '_')"
    attr_value="$(echo "${line}" | tr '=' ':' | cut -f2 -d: | sed 's/^ \+//g')"
    case "${attr_type}" in
    number_of_hours_powered_up_) power_on="$(echo "${attr_value}" | awk '{ printf "%e\n", $1 }')" ;;
    Current_Drive_Temperature) temp_cel="$(echo ${attr_value} | cut -f1 -d' ' | awk '{ printf "%e\n", $1 }')" ;;
    Blocks_read_from_cache_and_sent_to_initiator_) lbas_read="$(echo ${attr_value} | awk '{ printf "%e\n", $1 }')" ;;
    Accumulated_start-stop_cycles) power_cycle="$(echo ${attr_value} | awk '{ printf "%e\n", $1 }')" ;;
    Elements_in_grown_defect_list) grown_defects="$(echo ${attr_value} | awk '{ printf "%e\n", $1 }')" ;;
    Non-medium_error_count) non_medium="$(echo ${attr_value} | awk '{ printf "%e\n", $1 }')" ;;
    read) read_uncorrected="$(echo ${attr_value} | awk '{ printf "%e\n", $7 }')" ;;
    write) write_uncorrected="$(echo ${attr_value} | awk '{ printf "%e\n", $7 }')" ;;
    verify) verify_uncorrected="$(echo ${attr_value} | awk '{ printf "%e\n", $7 }')" ;;
    esac
  done
  [ ! -z "$power_on" ] && echo "power_on_hours_raw_value{${labels},smart_id=\"9\"} ${power_on}"
  [ ! -z "$temp_cel" ] && echo "temperature_celsius_raw_value{${labels},smart_id=\"194\"} ${temp_cel}"
  [ ! -z "$lbas_read" ] && echo "total_lbas_read_raw_value{${labels},smart_id=\"242\"} ${lbas_read}"
  [ ! -z "$power_cycle" ] && echo "power_cycle_count_raw_value{${labels},smart_id=\"12\"} ${power_cycle}"
  [ ! -z "$grown_defects" ] && echo "sas_grown_defects_count_raw_value{${labels},smart_id=\"0\"} ${grown_defects}"
  [ ! -z "$non_medium" ] && echo "sas_non_medium_errors_count_raw_value{${labels},smart_id=\"0\"} ${non_medium}"
  [ ! -z "$read_uncorrected" ] && echo "sas_read_uncorrected_errors_count_raw_value{${labels},smart_id=\"0\"} ${read_uncorrected}"
  [ ! -z "$write_uncorrected" ] && echo "sas_write_uncorrected_errors_count_raw_value{${labels},smart_id=\"0\"} ${write_uncorrected}"
  [ ! -z "$verify_uncorrected" ] && echo "sas_verify_uncorrected_errors_count_raw_value{${labels},smart_id=\"0\"} ${verify_uncorrected}"
}

parse_smartctl_info() {
  local -i smart_available=0 smart_enabled=0 smart_healthy=0
  local disk="$1" disk_type="$2" name="$3"
  local model_family='N/A' device_model='N/A' size='N/A' serial_number='N/A' fw_version='N/A' vendor='N/A' product='N/A' revision='N/A' lun_id='N/A'
  while read line; do
    info_type="$(echo "${line}" | cut -f1 -d: | tr ' ' '_')"
    info_value="$(echo "${line}" | cut -f2- -d: | sed 's/^ \+//g' | sed 's/"/\\"/')"
    case "${info_type}" in
    Model_Family) model_family="${info_value}" ;;
    Device_Model) device_model="${info_value}" ;;
    Serial_[Nn]umber) serial_number="${info_value}" ;;
    Firmware_Version) fw_version="${info_value}" ;;
    User_Capacity) size="$(echo ${info_value}| sed -E 's/\s+.+$//g' | tr -d ','| awk '{printf "%d GB\n", $1/1024/1024/1024}')" ;;
    Vendor) vendor="${info_value}" ;;
    Product) product="${info_value}" ;;
    Revision) revision="${info_value}" ;;
    Logical_Unit_id) lun_id="${info_value}" ;;
    esac
    if [[ "${info_type}" == 'SMART_support_is' ]]; then
      case "${info_value:0:7}" in
      Enabled) smart_enabled=1 ;;
      Availab) smart_available=1 ;;
      Unavail) smart_available=0 ;;
      esac
    fi
    if [[ "${info_type}" == 'SMART_overall-health_self-assessment_test_result' ]]; then
      info_value=`echo ${info_value}| tr -d ' '`
      case "${info_value}" in
      PASSED) smart_healthy=1 ;;
      esac
    elif [[ "${info_type}" == 'SMART_Health_Status' ]]; then
      info_value=`echo ${info_value}| tr -d ' '`
      case "${info_value}" in
      OK) smart_healthy=1 ;;
      esac
    fi
  done
  if [[ $device_model == 'N/A' ]] && ([[ $vendor != 'N/A' ]] || [[ $product != 'N/A'  ]])
    then
    device_model="${vendor} $product"
  fi
  echo "device_info{disk=\"${disk}\",type=\"${disk_type}\",name=\"${name}\",vendor=\"${vendor}\",product=\"${product}\",revision=\"${revision}\",lun_id=\"${lun_id}\",model_family=\"${model_family}\",device_model=\"${device_model}\",serial_number=\"${serial_number}\",size=\"${size}\",firmware_version=\"${fw_version}\",smart_healthy=\"${smart_healthy}\"} 1"
  echo "device_smart_available{disk=\"${disk}\",type=\"${disk_type}\",name=\"${name}\"} ${smart_available}"
  echo "device_smart_enabled{disk=\"${disk}\",type=\"${disk_type}\",name=\"${name}\"} ${smart_enabled}"
  echo "device_smart_healthy{disk=\"${disk}\",type=\"${disk_type}\",name=\"${name}\"} ${smart_healthy}"
}

output_format_awk="$(
  cat <<'OUTPUTAWK'
BEGIN { v = "" }
v != $1 {
  print "# HELP smartmon_" $1 " SMART metric " $1;
  print "# TYPE smartmon_" $1 " gauge";
  v = $1
}
{print "smartmon_" $0}
OUTPUTAWK
)"

format_output() {
  sort |
    awk -F'{' "${output_format_awk}"
}

smartctl_version="$($SMARTCTL -V | head -n1 | awk '$1 == "smartctl" {print $2}')"

echo "smartctl_version{version=\"${smartctl_version}\"} 1" | format_output

if [[ "$(expr "${smartctl_version}" : '\([0-9]*\)\..*')" -lt 6 ]]; then
  exit
fi

device_list=
if [[ -z $FORCED_DEVICE_LIST ]]
  then
  device_list="$($SMARTCTL --scan-open | awk '/^\/dev/{print $1 "|" $3}')"
else
  device_list=$FORCED_DEVICE_LIST
fi

for device in ${device_list}; do
  disk="$(echo ${device} | cut -f1 -d'|')"
  type="$(echo ${device} | cut -f2 -d'|')"
  active=1
  # Check if the device is in a low-power mode
  $SMARTCTL -n standby -d "${type}" "${disk}" > /dev/null || active=0
  echo "device_active{disk=\"${disk}\",type=\"${type}\"}" "${active}"
  # Skip further metrics to prevent the disk from spinning up
  test ${active} -eq 0 && continue
  # Get Device name label
  name=""
  case ${type} in
    scsi)
      vendor=`$SMARTCTL -i -d "${type}" "${disk}" | awk -F ':' '/Vendor/ {print $2}'| sed -E 's/^\s+//g'`
      product=`$SMARTCTL -i -d "${type}" "${disk}" | awk -F ':' '/Product/ {print $2}'| sed -E 's/^\s+//g'`
      name="${vendor} ${product}" ;;
    *)
      name=`$SMARTCTL -i -d "${type}" "${disk}" | awk -F ':' '/Device Model/ {print $2}'| sed -E 's/^\s+//g'` ;;
  esac
  echo "smartctl_run{disk=\"${disk}\",type=\"${type}\",name=\"${name}\"}" "$(TZ=UTC date '+%s')"
  # Get the SMART information and health
  $SMARTCTL -i -H -d "${type}" "${disk}" | parse_smartctl_info "${disk}" "${type}" "${name}"
  # Get the SMART attributes
  case ${type} in
    sat) $SMARTCTL -A -d "${type}" "${disk}" | parse_smartctl_attributes "${disk}" "${type}" "${name}" ;;
    atacam) $SMARTCTL -A -d "${type}" "${disk}" | parse_smartctl_attributes "${disk}" "${type}" "${name}" ;;
    sat+megaraid*) $SMARTCTL -A -d "${type}" "${disk}" | parse_smartctl_attributes "${disk}" "${type}" "${name}" ;;
    scsi) $SMARTCTL -a -d "${type}" "${disk}" | parse_smartctl_scsi_attributes "${disk}" "${type}" "${name}" ;;
    megaraid*) $SMARTCTL -A -d "${type}" "${disk}" | parse_smartctl_scsi_attributes "${disk}" "${type}" "${name}" ;;
    *)
      continue
      ;;
  esac
done | format_output
