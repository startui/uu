#!/bin/bash

# 获取所有网络接口名称
interfaces=$(ip link show | awk -F': ' '/^[0-9]+:/{print $2}')

# 初始化总流量变量
total_rx_bytes=0
total_tx_bytes=0

# 遍历每个接口并累加流量信息
for interface in $interfaces; do
    # 获取入站流量
    rx_bytes=$(ifconfig $interface | grep "RX packets\|RX bytes" | awk '{print $5, $8}')
    total_rx_bytes=$((total_rx_bytes + rx_bytes))

    # 获取出站流量
    tx_bytes=$(ifconfig $interface | grep "TX packets\|TX bytes" | awk '{print $5, $8}')
    total_tx_bytes=$((total_tx_bytes + tx_bytes))
done

# 转换为人类可读的格式
total_rx_human=$(echo $total_rx_bytes | awk '{ sum=$1 ; hum[1024^3]="GB";hum[1024^2]="MB";hum[1024]="KB"; for (x=1024^3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}')
total_tx_human=$(echo $total_tx_bytes | awk '{ sum=$1 ; hum[1024^3]="GB";hum[1024^2]="MB";hum[1024]="KB"; for (x=1024^3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}')

# 打印结果
echo "下载：$total_rx_human"
echo "上传：$total_tx_human"

