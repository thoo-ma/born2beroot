#!/bin/bash

# SYSTEM DATA

system=$(uname -a)

# BOOT DATA

last_boot=$(who -b | awk '{print $3 " " $4}')

# LVM DATA

if (lvs | tail -n+2 | awk '{print $3}' | awk -F "" '{print $5}' | grep -q a)
then
  lvm_status="yes"
else
  lvm_status="no"
fi

# CPU DATA

virtual_CPU=$(cat /proc/cpuinfo | grep processor | awk -F " " '{print $3}')
physical_CPU=$(lscpu | grep '^CPU(s)' | awk -F " " '{print $2}')
cpu_usage=$(mpstat 1 4 | tail -n 1 | awk '{print 100.00-$12}')

# MEM DATA

mem_total=$(free | grep Mem | awk '{print $2}')
mem_usage=$(free | grep Mem | awk '{print $3}')
mem_percentage=$(free | grep Mem | awk '{print $3/$2 * 100}')
#mem_total=$(cat /proc/meminfo | grep MemTotal | awk '{print $2 $3}')

# DISK DATA

disk_total=$(df -h | grep /dev/mapper/ | awk '{print $2}')
disk_usage=$(df -h | grep /dev/mapper/ | awk '{print $3}')
disk_percentage=$(df -h | grep /dev/mapper/ | awk '{print $5}')

# IP DATA

ipv4addr=$(hostname -I)
mac_addr=$(ip addr | grep ether | awk '{print $2}')

# TCP DATA

tcp=$(netstat | grep tcp | wc -l)

# USERS DATA

users=$(who | wc -l)

# SUDO DATA

sudo_cmd=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)

# WALL MONITORING

wall "$system
Last boot      : $last_boot
LVM enable     : $lvm_status
Virtual CPUs   : $virtual_CPU
Physical CPUs  : $physical_CPU 
CPU usage      : $cpu_usage%
Memory usage   : $mem_usage/$mem_total ($mem_percentage%)
Disk usage     : $disk_usage/$disk_total ($disk_percentage)
TCP Connexions : $tcp
Users logged   : $users
IPV4 Address   : $ipv4addr
MAC Address    : $mac_addr
Sudo commands  : $sudo_cmd"
