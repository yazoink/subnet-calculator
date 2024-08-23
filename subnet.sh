#!/bin/bash

MIN_SUBNET=1
MAX_SUBNET=4

main() { 
    subnetNum=""
    borrowedBits=0
    hostBits=0
    hostsPerSubnet=0
    subnetMask=0
    cidr=24

    while [[ 1 ]]; do
        read -p "Enter number of subnets: " subnetNum
        if isNum "$subnetNum" -eq 1; then
            if [[ $subnetNum -ge MIN_SUBNET ]] && [[ $subnetNum -le MAX_SUBNET ]]; then
                break
            fi
        fi
    done
}

isNum() {
    if [[ $1 =~ '^[0-9]+$' ]]; then
        echo num
        return 1
    else
        echo not num
        return -1
    fi
}

main
