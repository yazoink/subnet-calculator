#!/usr/bin/env python3

MIN_SUBNET = 1
MAX_SUBNET = 64

def main():
    while True:
        subnetNum = input("Enter number of subnets (" + str(MIN_SUBNET) + "-" + str(MAX_SUBNET) + "): ")
        if subnetNum.isdigit() == True and int(subnetNum) in range(MIN_SUBNET, MAX_SUBNET + 1):
            break

    subnetNum = int(subnetNum)    
    
    borrowedBits = 0
    while pow(2, borrowedBits) < subnetNum:
        borrowedBits += 1

    hostBits = 8 - borrowedBits
    addressesPerSubnet = pow(2, hostBits)
    hostsPerSubnet = addressesPerSubnet - 2
    subnetMask = 255 - addressesPerSubnet + 1
    cidr = 24 + borrowedBits

    print("Bits Borrowed: " + str(borrowedBits))
    print("Binary Last Byte in SNM: " + format(subnetMask, '08b'))
    print("Subnets: " + str(subnetNum))
    print("Addresses Per Subnet: " + str(addressesPerSubnet))
    print("Hosts Per Subnet: " + str(hostsPerSubnet))
    print("Subnet Mask: ." + str(subnetMask))
    print("CIDR: /" + str(cidr))
    
main()