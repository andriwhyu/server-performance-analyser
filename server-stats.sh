#!/bin/bash

function get_cpu_usage () {
    cpu_usage_total=$(mpstat | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')
    echo "CPU usage all: ${cpu_usage_total}%"
}

function get_memory_information() {
    free -m | awk 'NR==2{ printf "Memory usage: %s/%s (%.2f%)\n", $3, $4, $3*100/$4 }'
}


function main() {
    scrape_interval=5 # in second

    while true; do
        get_cpu_usage
        get_memory_information

        sleep ${scrape_interval}
    done

}

main "$@"