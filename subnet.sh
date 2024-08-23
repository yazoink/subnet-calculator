#!/bin/bash

MIN_SUBNET=1
MAX_SUBNET=64

main() {
    if [[ "$1" != "" ]]; then
        help
        exit 1
    fi

    while [[ 1 ]]; do
        while [[ 1 ]]; do
            read -p "Enter number of subnets ($MIN_SUBNET-$MAX_SUBNET): " subnetNum
            if isNum "$subnetNum"; then
                if (($subnetNum >= $MIN_SUBNET && $subnetNum <= $MAX_SUBNET)); then
                    break
                fi
            fi
        done
        
        borrowedBits=0
        result=$((2 ** borrowedBits))
        while [[ $result -lt $subnetNum ]]; do
            borrowedBits=$((borrowedBits + 1))
            result=$((2 ** borrowedBits))
        done

        binary=(0 0 0 0 0 0 0 0)
        for ((i=0; i<$borrowedBits; i++)); do
            binary[i]=1
        done
        
        hostBits=$((8 - borrowedBits))
        addressesPerSubnet=$((2 ** hostBits))
        hostsPerSubnet=$((addressesPerSubnet - 2))
        subnetMask=$((255 - addressesPerSubnet + 1))
        cidr=$((24 + borrowedBits))

        printf "Bits Borrowed: %d\n" $borrowedBits
        
        printf "Binary last Byte in SNM: "
        for elem in ${binary[@]}; do
            printf "%d" $elem
        done
        printf "\n"

        printf "Subnets: %d\n" $subnetNum
        printf "Addresses Per Subnet: %d\n" $addressesPerSubnet
        printf "Hosts Per Subnet: %d\n" $hostsPerSubnet
        printf "Subnet Mask: .%d\n" $subnetMask
        printf "CIDR: /%d\n" $cidr

        yesOrNo='a'
        while [[ "${yesOrNo^^}" != "YES" ]] && [[ "${yesOrNo^^}" != "Y" ]] && [[ "${yesOrNo^^}" != "NO" ]] && [[ "${yesOrNo^^}" != "N" ]] && [[ "${yesOrNo^^}" != "" ]]; do
            read -p "Continue? (Y/n): " yesOrNo
        done
        if [[ "${yesOrNo^^}" = "NO" ]] || [[ "${yesOrNo^^}" = "N" ]]; then
            exit 0
        fi
    done
}

help() {
    printf "Usage: ./subnet.sh\n"
}

isNum() {
    re='^[0-9]+$'
    if [[ $1 =~ $re ]]; then
        return 0
    else
        return 1
    fi
}

main "${@}"