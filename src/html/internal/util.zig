const std = @import("std");
const Entity = @import("entity.zig").Entity;

pub fn fetch_entity(field: anytype) ?Entity {
    const typeof = @TypeOf(field);
    return switch (typeof) {
        Entity => field,
        fn (?[]const u8) Entity => field(null),
        fn (anytype) Entity => field(.{}),
        fn (anytype) (fn (anytype) Entity) => field(.{})(.{}),
        else => {
            const typename = @typeName(typeof);
            if (std.mem.startsWith(u8, typename, "*const [") and std.mem.endsWith(u8, typename, ":0]u8")) {
                return Entity{
                    .definition = .{
                        .text = .{
                            .sanitize = false,
                            .value = field,
                        },
                    },
                    .transform = struct {
                        fn lambda() []const u8 {
                            return field;
                        }
                    }.lambda,
                };
            }
            return null;
        },
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
