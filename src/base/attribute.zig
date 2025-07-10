const std = @import("std");
const unicode = std.unicode;
const constant = @import("constant.zig");

pub const Attribute = struct {
    name: []const u8,
    value: ?[]const u8,

    pub fn init(name: []const u8, value: ?[]const u8) Attribute {
        return Attribute{
            .name = name,
            .value = value,
        };
    }

    pub fn validate(self: @This()) void {
        validate_name(self.name);
        validate_value(self.value);
    }

    pub fn validate_name(name: []const u8) void {
        if (name.len == 0) {
            @compileError("InvalidAttributeName: must not be empty");
        }

        const illegal_codepoints = [_]u21{
            0x20,
            0x22,
            0x27,
            0x2F,
            0x3D,
            0x3E,
        };
        const utf8_view = try unicode.Utf8View.init(name);
        var utf8_iter = utf8_view.iterator();
        var has_illegal_codepoint = false;

        const max_branches = 1000 + (name.len * 100);
        @setEvalBranchQuota(max_branches);

        while (utf8_iter.nextCodepoint() and !has_illegal_codepoint) |codepoint| {
            has_illegal_codepoint = has_illegal_codepoint or contains(illegal_codepoints, codepoint);
            has_illegal_codepoint = has_illegal_codepoint or contains(constant.CONTROL_CODEPOINTS, codepoint);
            has_illegal_codepoint = has_illegal_codepoint or contains(constant.NONCHARACTER_CODEPOINTS, codepoint);
        }

        if (has_illegal_codepoint) {
            @compileError("InvalidAttributeName: \"" ++ name ++ "\" contains illegal character");
        }
    }

    pub fn validate_value(value: ?[]const u8) void {
        if (value) |string| {
            var left: usize = 0;
            const length = string.len;

            const max_branches = string.len * constant.NAMED_CHARACTERS.kvs.len * std.math.log2_int_ceil(usize, constant.NAMED_CHARACTERS.kvs.len);
            @setEvalBranchQuota(max_branches);

            while (left < length) : (left += 1) {
                if (string[left] == '&') {
                    var right = left;
                    while (right < length and string[right] != ';') : (right += 1) {}
                    const selection = string[left..@min(right + 1, length)];

                    if (selection[selection.len - 1] == ';') {
                        var buffer: [selection.len]u8 = undefined;
                        const entity = std.ascii.lowerString(&buffer, selection);
                        if (!constant.NAMED_CHARACTERS.has(entity)) {
                            @compileError("InvalidAttributeValue: \"" ++ entity ++ "\" contains ambiguous ampersand");
                        }
                    }
                }
            }
        }
    }
};

pub const DataAttribute = struct {
    pub fn init(name: []const u8, value: ?[]const u8) Attribute {
        return Attribute{
            .name = "data-" ++ name,
            .value = value,
        };
    }
};

pub const InteractiveAttribute = struct {
    pub fn init(name: []const u8, value: ?[]const u8) Attribute {
        return Attribute{
            .name = "aria-" ++ name,
            .value = value,
        };
    }
};

fn contains(slices: []const u21, target: []const u21) bool {
    return std.mem.containsAtLeast(u21, slices, 1, target);
}
