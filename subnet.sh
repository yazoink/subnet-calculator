#!/bin/bash

MIN_SUBNET=1
MAX_SUBNET=64

main() {
    if [[ "$1" != "" ]]; then # if user entered any commandline args, show help/usage and exit
        help "${@}"
    fi

    while true; do
        while true; do # this chunk of code prompts the user for a number of subnets, makes sure it's a number and makes sure it's between 1 and 64
            read -r -p "Enter number of subnets ($MIN_SUBNET-$MAX_SUBNET): " subnetNum
            if isNum "$subnetNum"; then
                if ((subnetNum >= MIN_SUBNET && subnetNum <= MAX_SUBNET)); then
                    break
                fi
            fi
        done
        
        borrowedBits=0
        result=$((2 ** borrowedBits))
        while [[ $result -lt $subnetNum ]]; do # while 2 to the power of number of borrowed bits is less than number of subnets
            borrowedBits=$((borrowedBits + 1)) # increment number of borrowed bits
            result=$((2 ** borrowedBits)) # (this chunk of finds the amount of borrowed bits needed)
        done

        binary=(0 0 0 0 0 0 0 0)
        for ((i=0; i<borrowedBits; i++)); do # for number of borrowed bits
            binary[i]=1 # change a 0 in the "binary" array to 1
        done
        
        hostBits=$((8 - borrowedBits))
        addressesPerSubnet=$((2 ** hostBits))
        hostsPerSubnet=$((addressesPerSubnet - 2))
        subnetMask=$((255 - addressesPerSubnet + 1))
        cidr=$((24 + borrowedBits))

        printf "~~~~~~~~~~\n"
        printf "Bits Borrowed: %d\n" $borrowedBits
        
        printf "Binary last Byte in SNM: "
        for elem in "${binary[@]}"; do # this makes sure the binary array is printed without spaces in between the bits
            printf "%d" "$elem"
        done
        printf "\n"

        printf "Subnets: %d\n" "$subnetNum"
        printf "Addresses Per Subnet: %d\n" $addressesPerSubnet
        printf "Hosts Per Subnet: %d\n" $hostsPerSubnet
        printf "Subnet Mask: .%d\n" $subnetMask
        printf "CIDR: /%d\n" $cidr
        printf "~~~~~~~~~~\n"

        answer='a'
        while ! exitProgramYesOrNo "$answer"; do
            read -r -p "Continue? (Y/n): " answer
        done
    done
}

exitProgramYesOrNo() { # check if input is a valid answer to (Y/n)
    case "${1^^}" in # "${str^^}" will convert a string to uppercase
        "YES" | "Y" | "")
            return 0
            ;;
        "NO" | "N") # if answer is no, exit program
            exit 0
            ;;
        *)
            return 1
            ;;
    esac
}

help() { # This is completely useless but every unix program has a usage/help function so I included it
    printf "Usage: ./subnet.sh\n"
    if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]] && [[ "$2" == "" ]]; then
        exit 0
    else
        exit 1
    fi
}

isNum() {
    re='^[0-9]+$' # regex -- from start of string, one or more numerical characters until end of string
    if [[ $1 =~ $re ]]; then # match given string with regex, return success if found and failure if not
        return 0
    else
        return 1
    fi
}

main "${@}" # "${@}" passes all commandline args to main function