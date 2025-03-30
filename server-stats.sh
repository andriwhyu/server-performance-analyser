#!/bin/bash

function get_cpu_usage () {
    mpstat | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }'
}


function main() {
    scrape_interval=60 # in second

    while true; do
        cpu_usage=$(get_cpu_usage)
        echo "custom_cpu_usage:${cpu_usage}"

        sleep ${scrape_interval}
    done
}

main "$@"