const std = @import("std");
const Entity = @import("entity.zig").Entity;

pub fn transform_attributes(attributes: anytype) []const u8 {
    const meta_fields = std.meta.fields(@TypeOf(attributes));
    return struct {
        fn transform(fields: []const std.builtin.Type.StructField) []const u8 {
            if (fields.len == 0) {
                return "";
            }

            for (fields) |field| {
                const argument = @field(attributes, field.name);
                const typeof = @TypeOf(argument);

                switch (typeof) {
                    Entity => {
                        if (argument.definition == .attribute) {
                            return " " ++ argument.transform() ++ transform(fields[1..]);
                        }
                    },
                    fn (?[]const u8) Entity => {
                        const normalized_argument = argument(null);
                        if (normalized_argument.definition == .attribute) {
                            return " " ++ normalized_argument.transform() ++ transform(fields[1..]);
                        }
                    },
                    else => {},
                }
            }

            return transform(fields[1..]);
        }
    }.transform(meta_fields);
}

pub fn transform_elements(elements: anytype) []const u8 {
    const meta_fields = std.meta.fields(@TypeOf(elements));
    return struct {
        fn transform(fields: []const std.builtin.Type.StructField) []const u8 {
            if (fields.len == 0) {
                return "";
            }

            for (fields) |field| {
                const argument = @field(elements, field.name);
                const typeof = @TypeOf(argument);

                switch (typeof) {
                    Entity => {
                        if (argument.definition != .attribute) {
                            return argument.transform() ++ transform(fields[1..]);
                        }
                    },
                    fn (anytype) Entity => {
                        const normalized_argument = argument(.{});
                        if (normalized_argument.definition != .attribute) {
                            return normalized_argument.transform() ++ transform(fields[1..]);
                        }
                    },
                    fn (anytype) (fn (anytype) Entity) => {
                        const normalized_argument = argument(.{})(.{});
                        if (normalized_argument.definition != .attribute) {
                            return normalized_argument.transform() ++ transform(fields[1..]);
                        }
                    },
                    else => {},
                }
            }

            return transform(fields[1..]);
        }
    }.transform(meta_fields);
}
