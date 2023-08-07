#!/bin/bash
while true; do
threshold=85899345920
rx_bytes=$(ifconfig eth0 | grep "RX packets\|RX bytes" | awk '{print $5, $8}')
tx_bytes=$(ifconfig eth0 | grep "TX packets\|TX bytes" | awk '{print $5, $8}')
used_bytes=$((rx_bytes + tx_bytes))
remaining_bytes=$((threshold - used_bytes))
function format_bytes() {
    local bytes=$1
    if ((bytes < 1024)); then
        echo "${bytes}B"
    elif ((bytes < 1048576)); then
        echo "$((bytes / 1024))KB"
    elif ((bytes < 1073741824)); then
        echo "$((bytes / 1048576))MB"
    else
        echo "$((bytes / 1073741824))GB"
    fi
}

used=$(format_bytes $used_bytes)
remaining=$(format_bytes $remaining_bytes)

# 输出已使用的流量和剩余流量
echo "已使用流量：$used"
echo "剩余流量：$remaining"

# 检查流量是否达到阈值
if [[ $used_bytes -ge $threshold ]]; then
    echo "流量超过阈值，将执行关机操作。"
    # 执行关机操作（需要root权限）
    sudo shutdown -h now
else
    echo "流量未达到阈值。"
fi
sleep 5
done
