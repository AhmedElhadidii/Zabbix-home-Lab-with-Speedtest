#!/usr/bin/env sh

set -e

DATA_FILE="/data/speedtest/speedtest.json"
MAX_AGE=${MAX_AGE:-3600} # Default to 1 hour

usage() {
  echo "Usage: \"$(basename "$0")\" OPTION"
  echo
  echo "-u: Display last measured upload speed"
  echo "-d: Display last measured download speed"
  echo "-j: Display last measured jitter"
  echo "-p: Display last measured ping latency"
  echo "-t: Display last measurement timestamp"
  echo "-s: Display last server used for measurements"
  echo "-m X: Set maximum data age to X seconds (default: $MAX_AGE)"
  echo "-f <file>: Specify data file (default: $DATA_FILE)"
  echo
  echo "-r|--run: Run speedtest (also runs if data is outdated)"
}

bytes_to_mbit() {
  echo "scale=2; $1 / 125000" | bc -l
}

get_data_timestamp() {
  jq -r '.timestamp | fromdate' "$DATA_FILE" 2>/dev/null || echo 0 
}

get_last_ping_time() {
  jq -r '.ping.latency' "$DATA_FILE"
}

get_last_jitter_time() {
  jq -r '.ping.jitter' "$DATA_FILE"
}

show_last_download_speed() {
  bytes_to_mbit "$(jq -r '.download.bandwidth' "$DATA_FILE")"
}

show_last_upload_speed() {
  bytes_to_mbit "$(jq -r '.upload.bandwidth' "$DATA_FILE")"
}

show_server_info() {
  data="$(jq -r '.server' "$DATA_FILE")"
  id="$(echo "$data" | jq -r '.id')"
  name="$(echo "$data" | jq -r '.name')"
  location="$(echo "$data" | jq -r '.location')"
  country="$(echo "$data" | jq -r '.country')"
  echo "$id: $name @$location ($country)"
}

data_is_outdated() {
  local data_ts now
  data_ts=$(get_data_timestamp)
  now=$(date '+%s')
  [[ "$(( now - data_ts ))" -gt "$MAX_AGE" ]]
}

run_speedtest() {

  speedtest --accept-license --accept-gdpr -f json > "$DATA_FILE"
}
# Argument parsing
ACTION=
PARAMS=""
while test "$#" -gt 0
do
  case "$1" in
    -h|--help|help)
      usage
      exit 0
      ;;
    -m|--max-age)
      MAX_AGE="$2"
      shift 2
      ;;
    -d|--download)
      ACTION=show_dl
      shift
      ;;
    -u|--upload)
      ACTION=show_ul
      shift
      ;;
    -j|--jitter)
      ACTION=show_jitter
      shift
      ;;
    -p|--ping)
      ACTION=show_ping
      shift
      ;;
    -s|--server)
      ACTION=show_server
      shift
      ;;
    -t|--timestamp)
      ACTION=show_timestamp
      shift
      ;;
    -f|--data-file)
      DATA_FILE="$2"
      shift 2
      ;;
    -r|--run)
      ACTION=run
      shift
      ;;
    --)
      # end argument parsing
      shift
      break
      ;;
    --*=|-*) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      usage
      exit 1
      ;;
    *)
      # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

# Run speedtest if data is outdated or explicitly requested
if [[ "$ACTION" != "run" ]] && data_is_outdated; then
  run_speedtest
fi

# Perform the requested action
case "$ACTION" in
  show_dl)
    show_last_download_speed
    ;;
  show_ul)
    show_last_upload_speed
    ;;
  show_jitter)
    get_last_jitter_time
    ;;
  show_ping)
    get_last_ping_time
    ;;
  show_server)
    show_server_info
    ;;
  show_timestamp)
    get_data_timestamp
    ;;
  run)
    run_speedtest
    ;;
  *)
    usage
    exit 2
esac