const std = @import("std");
const unicode = std.unicode;
const internal = @import("internal");
const constant = internal.constant;

pub fn validate_name(name: []const u8) void {
    if (name.len == 0) {
        @compileError("InvalidAttributeName: must not be empty");
    }

    const illegal_codepoints = &[_]u21{
        0x20,
        0x22,
        0x27,
        0x2F,
        0x3D,
        0x3E,
    };
    const utf8_view = try unicode.Utf8View.init(name);
    var utf8_iter = utf8_view.iterator();
    var is_illegal = false;

    const max_branches = 1000 + name.len;
    @setEvalBranchQuota(max_branches);

    while (utf8_iter.nextCodepoint()) |codepoint| {
        if (is_illegal) {
            break;
        }

        is_illegal = is_illegal or codepoint < 0x00 or codepoint >= 0x00EFB790;
        is_illegal = is_illegal or contains(illegal_codepoints, codepoint);
        is_illegal = is_illegal or contains(constant.codepoint.CONTROL_CODEPOINT, codepoint);
    }

    if (is_illegal) {
        @compileError("InvalidAttributeName: \"" ++ name ++ "\" contains illegal character");
    }
}

pub fn validate_value(value: ?[]const u8) void {
    if (value) |string| {
        var left: usize = 0;
        const length = string.len;

        const named_character = constant.codepoint.NAMED_CHARACTER_CODEPOINT;
        const max_branches = string.len * named_character.kvs.len * std.math.log2_int_ceil(usize, named_character.kvs.len);
        @setEvalBranchQuota(max_branches);

        while (left < length) : (left += 1) {
            if (string[left] == '&') {
                var right = left;
                while (right < length and string[right] != ';') : (right += 1) {}
                const selection = string[left..@min(right + 1, length)];

                if (selection[selection.len - 1] == ';') {
                    var buffer: [selection.len]u8 = undefined;
                    const entity = std.ascii.lowerString(&buffer, selection);
                    if (!named_character.has(entity)) {
                        @compileError("InvalidAttributeValue: \"" ++ entity ++ "\" contains ambiguous ampersand");
                    }
                }
            }
        }
    }
}

fn contains(slices: []const u21, target: u21) bool {
    return std.mem.containsAtLeast(u21, slices, 1, &[_]u21{target});
}
