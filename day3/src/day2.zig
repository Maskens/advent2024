const std = @import("std");

const State = enum { detect_prefix, read_first_number, read_second_number };

const ParseNumberState = enum { reading, err, done };

const ParseNumber = struct {
    index: u8 = 0,
    limit: u8 = 3,
    numberChars: [3]u8 = [_]u8{ 'x', 'x', 'x' },
    limit_char: u8,
    state: ParseNumberState = ParseNumberState.reading,

    fn tryReadDigit(self: *ParseNumber, d: u8) ParseNumberState {
        if (!std.ascii.isDigit(d) and (d != self.limit_char)) {
            return ParseNumberState.err;
        }

        if (d == self.limit_char and self.index > 0) {
            return ParseNumberState.done;
        }

        // Read number
        if (self.index > self.numberChars.len - 1) {
            return ParseNumberState.err;
        }

        self.numberChars[self.index] = d;
        self.index += 1;

        return ParseNumberState.reading;
    }

    fn getNumber(self: *ParseNumber) u32 {
        const number = self.numberChars[0..self.index];
        return std.fmt.parseInt(u32, number, 10) catch unreachable;
    }
};

pub fn main() !void {
    const input_str = try std.fs.cwd().readFileAlloc(
        std.heap.page_allocator,
        "real_input_pt2.txt",
        99999,
    );
    std.debug.print("{s}", .{input_str});

    const prefix: []const u8 = "mul(";
    const do_prefix: []const u8 = "do()";
    const dont_prefix: []const u8 = "don't()";
    var prefix_state_index: u8 = 0;

    var cur_state = State.detect_prefix;
    var parseNumber = ParseNumber{ .limit_char = ',' };

    var first_number: u32 = 0;
    var second_number: u32 = 0;

    var total: u32 = 0;

    var do = true;

    for (input_str, 0..) |char, i| {
        switch (cur_state) {
            .detect_prefix => {
                if (prefix[prefix_state_index] == char) {
                    prefix_state_index += 1;

                    if (prefix_state_index == prefix.len) {
                        cur_state = State.read_first_number;
                        parseNumber = ParseNumber{ .limit_char = ',' };
                        prefix_state_index = 0;
                    }
                } else prefix_state_index = 0;

                // Try detect do or dont_prefix
                if (i <= input_str.len - 6) {
                    const do_slice = input_str[i..(i + 4)];
                    // std.debug.print("{s}", .{do_slice});
                    const dont_slice = input_str[i..(i + 7)];
                    if (std.mem.eql(u8, do_slice, do_prefix)) {
                        do = true;
                        std.debug.print("Do!", .{});
                    } else if (std.mem.eql(u8, dont_slice, dont_prefix)) {
                        do = false;
                        std.debug.print("Dont!", .{});
                    }
                }
            },
            .read_first_number => {
                const result = parseNumber.tryReadDigit(char);

                if (result == ParseNumberState.reading) {
                    continue;
                }

                if (result == ParseNumberState.done) {
                    cur_state = State.read_second_number;
                    first_number = parseNumber.getNumber();
                    parseNumber = ParseNumber{ .limit_char = ')' };
                }

                if (result == ParseNumberState.err) {
                    prefix_state_index = 0;
                    cur_state = State.detect_prefix;
                }
            },
            .read_second_number => {
                const result = parseNumber.tryReadDigit(char);

                if (result == ParseNumberState.reading) {
                    continue;
                }

                if (result == ParseNumberState.done) {
                    second_number = parseNumber.getNumber();

                    if (do) {
                        total += first_number * second_number;
                    }
                    cur_state = State.detect_prefix;
                    prefix_state_index = 0;
                }

                if (result == ParseNumberState.err) {
                    cur_state = State.detect_prefix;
                    prefix_state_index = 0;
                }
            },
        }
    }

    std.debug.print("Done, number is {d}\n", .{total});
}
