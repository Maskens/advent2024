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
        "real_input.txt",
        99999,
    );
    std.debug.print("{s}", .{input_str});

    const prefix: []const u8 = "mul(";
    var prefix_state_index: u8 = 0;

    var cur_state = State.detect_prefix;
    var parseNumber = ParseNumber{ .limit_char = ',' };

    var first_number: u32 = 0;
    var second_number: u32 = 0;

    var total: u32 = 0;

    for (input_str) |char| {
        switch (cur_state) {
            .detect_prefix => {
                if (prefix[prefix_state_index] == char) {
                    // std.debug.print("{c}", .{char});
                    prefix_state_index += 1;

                    if (prefix_state_index == prefix.len) {
                        cur_state = State.read_first_number;
                        parseNumber = ParseNumber{ .limit_char = ',' };
                        prefix_state_index = 0;
                    }
                } else prefix_state_index = 0;
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
                    total += first_number * second_number;
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

test "simple test" {
    const input = "134,";
    var parseNumber = ParseNumber{ .limit_char = ',' };

    var result: ParseNumberState = undefined;

    for (input) |char| {
        result = parseNumber.tryReadDigit(char);

        if (result == ParseNumberState.err or result == ParseNumberState.done) {
            break;
        }
    }

    const number = parseNumber.getNumber();

    try std.testing.expectEqual(result, ParseNumberState.done);
    try std.testing.expectEqual(number, 134);
}

test "2" {
    const input = "x3,";
    var parseNumber = ParseNumber{ .limit_char = ',' };

    var result: ParseNumberState = undefined;

    for (input) |char| {
        result = parseNumber.tryReadDigit(char);

        if (result == ParseNumberState.err or result == ParseNumberState.done) {
            break;
        }
    }

    try std.testing.expectEqual(result, ParseNumberState.err);
}

test "3" {
    const input = "3,";
    var parseNumber = ParseNumber{ .limit_char = ',' };

    var result: ParseNumberState = undefined;

    for (input) |char| {
        result = parseNumber.tryReadDigit(char);

        if (result == ParseNumberState.err or result == ParseNumberState.done) {
            break;
        }
    }

    const number = parseNumber.getNumber();
    try std.testing.expectEqual(result, ParseNumberState.done);
    try std.testing.expectEqual(number, 3);
}

test "4" {
    const input = "3123,";
    var parseNumber = ParseNumber{ .limit_char = ',' };

    var result: ParseNumberState = undefined;

    for (input) |char| {
        result = parseNumber.tryReadDigit(char);

        if (result == ParseNumberState.err or result == ParseNumberState.done) {
            break;
        }
    }

    try std.testing.expectEqual(result, ParseNumberState.err);
}

test "5" {
    const input = "3123";
    var parseNumber = ParseNumber{ .limit_char = ',' };

    var result: ParseNumberState = undefined;

    for (input) |char| {
        result = parseNumber.tryReadDigit(char);

        if (result == ParseNumberState.err or result == ParseNumberState.done) {
            break;
        }
    }

    try std.testing.expectEqual(result, ParseNumberState.err);
}
