
index_str=${1:-"7s"}
data_link="https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/agoric-mainnet/agoric_snapsot_latest.json"
snap_link="https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/agoric-mainnet/agoric_snapsot_latest.tar.lz4"
memory=$(curl -sI $snap_link | grep -i Content-Length | awk '{print  $2 / (1024^3)}')

json_file=$(curl -H GET $data_link | jq '.')

echo "Get height"
height=$(echo $json_file| jq -r '.latest_block_height')
echo "height: $height"

echo "Get time"
start_date=$(echo $json_file| jq -r '.latest_block_time')
echo "latest_block_time: $start_date"

current_time=$(date +%s)
start_time=$(date -d "$start_date" +%s)
time_difference=$((current_time - start_time))

time_hour=$((time_difference / 3600))

echo "hour: $time_hour"

changed_str="|   $height   |  $time_hour hourss | [Snapshot ($(printf '%.1f' $memory) GB)]($snap_link)  |"


sed -i "$index_str>.*>$changed_str>" snapshot-and-state-sync.md

