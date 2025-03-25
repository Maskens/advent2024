const std = @import("std");

const Direction = enum { noop, same, increasing, decreasing };

pub fn main() !void {
    const safetyDamper = true;
    try day1(safetyDamper);
}

fn day1(safetyDamper: bool) !void {
    const content = try readFile("real_input.txt", std.heap.page_allocator);

    var lines = std.mem.splitSequence(u8, content, "\n");

    var noOfSafe: u32 = 0;

    while (lines.next()) |line| {
        var numberList = std.ArrayList(u32).init(std.heap.page_allocator);
        defer numberList.deinit();

        try getNumberSeries(line, &numberList);

        if (numberList.items.len == 0) break;

        printList(&numberList);

        const safe = isSafe(numberList.items);

        if (safe) {
            std.debug.print(" Safe!", .{});
            noOfSafe += 1;
        } else {
            std.debug.print(" Not safe!", .{});

            if (safetyDamper) {
                std.debug.print(" Using safetyDamper...", .{});

                const numbers_len = numberList.items.len;

                for (0..numbers_len) |i| {
                    var new_list = try numberList.clone();
                    defer new_list.deinit();
                    _ = new_list.orderedRemove(i);
                    if (isSafe(new_list.items)) {
                        noOfSafe += 1;
                        std.debug.print("Saved by removing item at '{d}', New list: ", .{i});
                        printList(&new_list);
                        break;
                    }
                }
            }
        }

        std.debug.print("\n", .{});
    }

    std.debug.print("{d}", .{noOfSafe});
}

fn printList(arrayList: *std.ArrayList(u32)) void {
    for (arrayList.items) |item| {
        std.debug.print("{d} ", .{item});
    }
}

fn getNumberSeries(string_numbers: []const u8, numbers: *std.ArrayList(u32)) !void {
    var number_iterator = std.mem.splitScalar(u8, string_numbers, ' ');

    while (number_iterator.next()) |number| {
        const n = std.fmt.parseInt(u32, number, 10) catch {
            break;
        };

        try numbers.*.append(n);
    }
}

fn getDirection(distance: i32) Direction {
    if (distance == 0) {
        return Direction.same;
    }

    if (distance > 0) {
        return Direction.increasing;
    }

    return Direction.decreasing;
}

fn getDistance(n1: i32, n2: i32) u32 {
    return @abs(n1 - n2);
}

const Result = struct { safe: bool, error_index: ?u8 };

fn isSafe(numbers: []u32) bool {
    var cur_direction: Direction = Direction.noop;
    var i: u8 = 0;
    while (i < numbers.len) : (i += 1) {
        if (i + 1 >= numbers.len) {
            break;
        }

        const num1: i32 = @intCast(numbers[i]);
        const num2: i32 = @intCast(numbers[i + 1]);

        const distance: i32 = num1 - num2;

        if (distance == 0 or @abs(distance) > 3) {
            return false;
        }

        if (cur_direction == Direction.noop) {
            cur_direction = getDirection(distance);
            continue;
        }

        if (getDirection(distance) != cur_direction) {
            return false;
        }
    }

    return true;
}

fn readFile(name: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const content = std.fs.cwd().readFileAlloc(allocator, name, 99999);

    return content;
}
