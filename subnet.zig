const std = @import("std");

const MIN_SUBNET: u32 = 1;
const MAX_SUBNET: u32 = 64;

pub fn int_pow(base: i32, exponent: i32) i32 {
    var i: i32 = 1;
    var res: i32 = base;

    if (exponent == 0) {
        return 1;
    }

    while (i < exponent) : (i += 1) {
        res = res * base;
    }
    return res;
}

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    var subnet_num: i32 = undefined;
    var borrowed_bits: i32 = 0;

    while (true) {
        var buffer: [255]u8 = undefined;
        std.debug.print(">> Enter a number of subnets ({d}-{d}): ", .{
            MIN_SUBNET,
            MAX_SUBNET,
        });
        if (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |user_input| {
            subnet_num = std.fmt.parseInt(i32, user_input, 10) catch {
                continue;
            };
            if (subnet_num >= MIN_SUBNET and subnet_num <= MAX_SUBNET) {
                break;
            }
        }
    }

    while (int_pow(2, borrowed_bits) < subnet_num) {
        borrowed_bits += 1;
    }

    const host_bits: i32 = 8 - borrowed_bits;
    const address_num: i32 = int_pow(2, host_bits);
    const host_num: i32 = address_num - 2;
    const subnet_mask: i32 = 255 - address_num + 1;
    const cidr: i32 = 24 + borrowed_bits;

    std.debug.print("Subnets: {d}\n", .{subnet_num});
    std.debug.print("Bits Borrowed: {d}\n", .{borrowed_bits});
    std.debug.print("Binary Last Byte in SNM: ", .{});
    if (subnet_mask == 0) {
        std.debug.print("00000000\n", .{});
    } else {
        std.debug.print("{b}\n", .{subnet_mask});
    }
    std.debug.print("Addresses Per Subnet: {d}\n", .{address_num});
    std.debug.print("Hosts Per Subnet: {d}\n", .{host_num});
    std.debug.print("Subnet Mask Last Byte: .{d}\n", .{subnet_mask});
    std.debug.print("CIDR: /{d}\n", .{cidr});
}
