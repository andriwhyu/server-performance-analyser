#!/bin/bash

function get_cpu_usage () {
    cpu_usage_total=$(mpstat | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')
    echo "CPU usage all: ${cpu_usage_total}%"
}

function get_memory_information() {
    free -m | awk 'NR==2{ printf "Memory usage: %s/%sM (%.2f%)\n", $3, $2, $3*100/$2 }'
}

function get_disk_information() {
  # calculate disk for native Linux
  disk_information=$(df --total | awk 'END { printf "Disk usage: %.0f/%.0fG (%s)\n", $3/1000000, $2/1000000, $5}')

  # calculate disk for WSL
  if grep -qi microsoft /proc/sys/kernel/osrelease; then
    disk_information=$(df / | awk 'END { printf "Disk usage: %.0f/%.0fG (%s)\n", $3/1000000, $2/1000000, $5}')
  fi

  echo "${disk_information}"
}

function top_cpu_process() {
  offset=$1

  ps -eo pid,ppid,comm,%cpu,%mem --sort=-pcpu | head -n $((offset + 1))
  echo ""
}

function top_memory_process() {
  offset=$1

  ps -eo pid,ppid,comm,%mem,%cpu --sort=-pmem | head -n $((offset + 1))
  echo ""
}


function main() {
    scrape_interval=5 # in second

    while true; do
      get_cpu_usage
      get_memory_information
      get_disk_information
      top_cpu_process 5
      top_memory_process 5

      sleep ${scrape_interval}
    done

}

main "$@"