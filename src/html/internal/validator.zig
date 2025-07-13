const constant = @import("constant.zig");
const std = @import("std");
const unicode = std.unicode;
const util = @import("util.zig");

pub const Attribute = struct {
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
        var has_illegal_codepoint = false;

        const max_branches = 1000 + name.len;
        @setEvalBranchQuota(max_branches);

        while (utf8_iter.nextCodepoint()) |codepoint| {
            if (has_illegal_codepoint) {
                break;
            }

            has_illegal_codepoint = has_illegal_codepoint or codepoint < 0x00 or codepoint >= 0x00EFB790;
            has_illegal_codepoint = has_illegal_codepoint or contains(illegal_codepoints, codepoint);
            has_illegal_codepoint = has_illegal_codepoint or contains(constant.CONTROL_CODEPOINTS, codepoint);
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

pub const Element = struct {
    pub fn validate_name(name: []const u8) void {
        for (name) |char| {
            var is_legal = false;

            is_legal = is_legal or ('a' <= char and char <= 'z');
            is_legal = is_legal or ('A' <= char and char <= 'Z');
            is_legal = is_legal or ('0' <= char and char <= '9');

            if (!is_legal) {
                @compileError("InvalidElementName: \"" ++ name ++ "\" contains non-alphanumeric character");
            }
        }
    }

    pub fn validate_attributes(attributes: anytype) void {
        const fields = std.meta.fields(@TypeOf(attributes));
        const error_message = "InvalidAttributeArgument: only attribute is allowed";

        for (fields) |field| {
            const entity = util.fetch_entity(@field(attributes, field.name));

            if (entity == null) {
                @compileError("InvalidAttributeArgument: unknown type");
            }

            if (entity.?.name != .Attribute) {
                @compileError(error_message);
            }
        }
    }

    pub fn validate_elements(elements: anytype) void {
        const fields = std.meta.fields(@TypeOf(elements));
        const error_message = "InvalidElementArgument: only element is allowed";

        for (fields) |field| {
            const entity = util.fetch_entity(@field(elements, field.name));

            if (entity == null) {
                @compileError("InvalidElementArgument: unknown type");
            }

            if (entity.?.name != .Element) {
                @compileError(error_message);
            }
        }
    }

    pub fn validate_arguments(args: anytype, comptime has_attributes: *bool) void {
        const fields = std.meta.fields(@TypeOf(args));
        if (fields.len > 0) {
            const entity = util.fetch_entity(@field(args, fields[0].name));

            if (entity == null) {
                @compileError("InvalidElementConstruct: unknown argument");
            }

            if (entity.?.name == .Attribute) {
                Element.validate_attributes(args);
            }

            if (entity.?.name == .Element) {
                Element.validate_elements(args);
                has_attributes.* = false;
            }
        }
    }
};

fn contains(slices: []const u21, target: u21) bool {
    return std.mem.containsAtLeast(u21, slices, 1, &[_]u21{target});
}
