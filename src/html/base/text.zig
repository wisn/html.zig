const std = @import("std");
const internal = @import("internal");
const transformer = @import("transformer");
const Entity = internal.entity.Entity;

pub fn RawText(texts: anytype) Entity {
    const collected_texts = collect_texts(texts);
    const entity = Entity{
        .definition = .{
            .text = .{
                .sanitize = false,
                .value = collected_texts,
            },
        },
    };

    return Entity{
        .definition = entity.definition,
        .transform = struct {
            fn lambda() []const u8 {
                return transformer.transform(.{entity});
            }
        }.lambda,
    };
}

pub fn Text(texts: anytype) Entity {
    const collected_texts = collect_texts(texts);
    const entity = Entity{
        .definition = .{
            .text = .{
                .sanitize = true,
                .value = collected_texts,
            },
        },
    };

    return Entity{
        .definition = entity.definition,
        .transform = struct {
            fn lambda() []const u8 {
                return transformer.transform(.{entity});
            }
        }.lambda,
    };
}

fn collect_texts(any: anytype) []const u8 {
    const meta_fields = std.meta.fields(@TypeOf(any));
    return struct {
        fn append(fields: []const std.builtin.Type.StructField) []const u8 {
            if (fields.len == 0) {
                return &[_]u8{};
            }

            const field = @field(any, fields[0].name);
            const typeof = @TypeOf(field);
            const typename = @typeName(typeof);

            if (!(std.mem.startsWith(u8, typename, "*const [") and std.mem.endsWith(u8, typename, ":0]u8"))) {
                @compileError("InvalidTextArgument: must be string literals");
            }

            return field ++ append(fields[1..]);
        }
    }.append(meta_fields);
}
