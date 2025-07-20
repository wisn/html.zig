const std = @import("std");
const constant = @import("constant/root.zig");
const Entity = @import("entity.zig").Entity;

pub fn fetch_entity(field: anytype) ?Entity {
    const typeof = @TypeOf(field);
    return switch (typeof) {
        Entity => field,
        fn (?[]const u8) Entity => field(null),
        fn (anytype) Entity => field(.{}),
        fn (anytype) (fn (anytype) Entity) => field(.{})(.{}),
        else => null,
    };
}

pub fn fetch_entity_list(any: anytype) []const Entity {
    const meta_fields = std.meta.fields(@TypeOf(any));
    return struct {
        fn append(fields: []const std.builtin.Type.StructField) []const Entity {
            if (fields.len == 0) {
                return &[_]Entity{};
            }

            const entity = fetch_entity(@field(any, fields[0].name));

            if (entity == null) {
                @compileError("InvalidEntityArgument: unknown type");
            }

            return &[_]Entity{entity.?} ++ append(fields[1..]);
        }
    }.append(meta_fields);
}

pub fn sanitize_text(text: []const u8) []const u8 {
    if (text.len == 0) {
        return "";
    }
    const char = switch (text[0]) {
        '<' => "&lt;",
        '>' => "&gt;",
        else => "" ++ &[_]u8{text[0]},
    };
    return char ++ sanitize_text(text[1..]);
}

pub fn has_undefined_attribute(attributes: *const []const Entity) bool {
    for (attributes.*) |attribute| {
        const attribute_name = attribute.definition.attribute.name;
        if (!constant.attribute.GLOBAL_ATTRIBUTE.has(attribute_name) and !constant.attribute.EVENT_HANDLER_ATTRIBUTE.has(attribute_name)) {
            return true;
        }
    }
    return false;
}
