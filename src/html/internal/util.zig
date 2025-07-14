const std = @import("std");
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
