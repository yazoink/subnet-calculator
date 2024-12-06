use std::io;
use std::io::Write;

const MIN_SUBNET: u32 = 1;
const MAX_SUBNET: u32 = 64;

fn main() {
    let subnet_num = get_subnet_num();
    let mut borrowed_bits: u32 = 0;
    while 2u32.pow(borrowed_bits) < subnet_num {
        borrowed_bits += 1;
    }
    let host_bits = 8 - borrowed_bits;
    let addresses_per_subnet = 2u32.pow(host_bits);
    let hosts_per_subnet = addresses_per_subnet - 2;
    let subnet_mask = 255 - addresses_per_subnet + 1;
    let cidr = 24 + borrowed_bits;

    println!("Bits borrowed: {}", borrowed_bits);
    println!("Last byte in subnet mask: {:b}", subnet_mask);
    println!("Subnets: {}", subnet_num);
    println!("Addresses per subnet: {}", addresses_per_subnet);
    println!("Hosts per subnet: {}", hosts_per_subnet);
    println!("Subnet mask: 255.255.255.{}", subnet_mask);
    println!("CIDR: /{}", cidr);
}

fn get_subnet_num() -> u32 {
    loop {
        let mut subnet_num = String::new();
        print!(">> enter number of subnets ({}-{}): ", MIN_SUBNET, MAX_SUBNET);
        io::stdout().flush().unwrap();
        io::stdin()
            .read_line(&mut subnet_num)
            .expect("Failed to read line.");

        let subnet_num: u32 = match subnet_num.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        if subnet_num >= MIN_SUBNET && subnet_num <= MAX_SUBNET {
            return subnet_num;
        }
    }
}
