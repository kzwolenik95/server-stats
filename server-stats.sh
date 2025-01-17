#!/usr/bin/env bash


function get_total_cpu_usage {
  LC_NUMERIC="en_GB.UTF-8" top -b -n1 -p 1 | awk -F'id,' -v prefix="$prefix" '/Cpu\(s\)/ { split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }'
}

function get_perc_free_mem {
  free | awk '/Mem/{printf "%.2f%%", 100*$4/$2}'
}

function get_perc_used_mem {
  free | awk '/Mem/{printf "%.2f%%", 100*$3/$2}'
}

function get_used_disk_perc {
  df -x tmpfs -x efivarfs --total | awk '/total/{print $5}'
}

function get_free_disk_perc {
  df -x tmpfs -x efivarfs --total | awk '/total/{print 100 - $5"%"}'
}

function get_top_5_cpu_proc {
  top -bn1 -o "%CPU" | grep 'PID USER' -A 5
}

function get_top_5_mem_proc {
  top -bn1 -o "%MEM" | grep 'PID USER' -A 5
}

function main {
  basic_info=$(uptime)
  total_cpu_usage=$(get_total_cpu_usage)
  free_mem_perc=$(get_perc_free_mem)
  used_mem_perc=$(get_perc_used_mem)
  used_disk_perc=$(get_used_disk_perc)
  free_disk_perc=$(get_free_disk_perc)
  top_5_cpu_proc=$(get_top_5_cpu_proc)
  top_5_mem_proc=$(get_top_5_mem_proc)

  printf "Uptime:%s\n" "$basic_info"
  printf "Total CPU usage on the machine: %s\n" "$total_cpu_usage"
  printf "Free memory %s and used memory %s\n" "$free_mem_perc" "$used_mem_perc"
  printf "Used disk space %s and free disk space %s\n" "$used_disk_perc" "$free_disk_perc"
  printf "Top 5 processed by %%CPU usage\n\n%s\n\n" "$top_5_cpu_proc"
  printf "Top 5 processed by %%MEM usage\n\n%s\n\n" "$top_5_mem_proc"
}

main