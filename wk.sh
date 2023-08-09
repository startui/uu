#!/bin/bash

# 获取所有网卡接口的名称
interfaces=$(ifconfig -s | awk '{print $1}')

# 遍历每个接口，检查是否正在运行
for interface in $interfaces; do
  status=$(cat /sys/class/net/$interface/operstate)
  if [ "$status" = "up" ]; then
    echo "当前网卡接口：$interface"
  fi
done
