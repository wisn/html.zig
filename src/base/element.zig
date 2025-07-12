const std = @import("std");
const transformer = @import("transformer.zig");
const util = @import("util.zig");
const validator = @import("validator.zig");
const Entity = @import("entity.zig").Entity;

pub fn Element(name: []const u8) fn (anytype) (fn (anytype) Entity) {
    validator.Element.validate_name(name);
    return struct {
        fn closure(args: anytype) fn (anytype) Entity {
            const fields = std.meta.fields(@TypeOf(args));
            comptime var has_attribute = true;

            if (fields.len > 0) {
                const entity = util.fetch_entity(@field(args, fields[0].name));

                if (entity == null) {
                    @compileError("InvalidElementConstruct: unknown argument");
                }

                if (entity.?.name == .Attribute) {
                    validator.Element.validate_attributes(args);
                }

                if (entity.?.name == .Element) {
                    validator.Element.validate_elements(args);
                    has_attribute = false;
                }
            }

            const attributes = if (has_attribute) args else .{};

            return struct {
                fn compose_children(children: anytype) Entity {
                    validator.Element.validate_elements(children);
                    const elements = if (has_attribute) children else args;

                    return Entity{
                        .name = .Element,
                        .transform = struct {
                            fn lambda() []const u8 {
                                const tag_start = "<" ++ name;
                                const tag_attributes = comptime transformer.transform_attributes(attributes);
                                const tag_close = ">";
                                const tag_children = comptime transformer.transform_elements(elements);
                                const tag_end = "</" ++ name ++ ">";
                                return tag_start ++ tag_attributes ++ tag_close ++ tag_children ++ tag_end;
                            }
                        }.lambda,
                    };
                }
            }.compose_children;
        }
    }.closure;
}

pub fn VoidElement(name: []const u8) fn (anytype) Entity {
    validator.Element.validate_name(name);
    return struct {
        fn compose_attributes(attributes: anytype) Entity {
            validator.Element.validate_attributes(attributes);
            return Entity{
                .name = .Element,
                .transform = struct {
                    fn lambda() []const u8 {
                        const tag_start = "<" ++ name;
                        const tag_attributes = comptime transformer.transform_attributes(attributes);
                        const tag_end = ">";
                        return tag_start ++ tag_attributes ++ tag_end;
                    }
                }.lambda,
            };
        }
    }.compose_attributes;
}

pub fn Text(raw_text: []const u8) Entity {
    return Entity{
        .name = .Element,
        .transform = struct {
            fn lambda() []const u8 {
                return raw_text;
            }
        }.lambda,
    };
}
