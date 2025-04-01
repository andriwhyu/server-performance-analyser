#!/bin/bash

function get_cpu_usage () {
    cpu_usage_total=$(mpstat | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')
    echo "custom_cpu_usage:${cpu_usage_total}"
}

function get_memory_information() {
    memory_used=$(free -m | awk 'NR==2{ print $3 }')
    memory_free=$(free -m | awk 'NR==2{ print $4 }')
    memory_percentage=$(free -m | awk 'NR==2{ printf "%.2f", $3*100/$4 }')

    echo "custom_memory_used_mb:${memory_used}"
    echo "custom_memory_free_mb:${memory_free}"
    echo "custom_memory_percent:${memory_percentage}"
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