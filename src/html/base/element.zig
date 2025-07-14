const std = @import("std");
const internal = @import("internal");
const transformer = internal.transformer;
const util = internal.util;
const validator = internal.validator;
const Entity = internal.entity.Entity;

pub fn Element(name: []const u8) fn (anytype) (fn (anytype) Entity) {
    validator.Element.validate_name(name);
    return struct {
        fn closure(args: anytype) fn (anytype) Entity {
            comptime var has_attributes = true;
            validator.Element.validate_arguments(args, &has_attributes);
            const attributes = if (has_attributes) args else .{};

            return struct {
                fn compose_children(children: anytype) Entity {
                    validator.Element.validate_elements(children);
                    const elements = if (has_attributes) children else args;

                    return Entity{
                        .definition = .{
                            .element = .{
                                .name = name,
                            },
                        },
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
                .definition = .{
                    .element = .{
                        .name = name,
                    },
                },
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

pub fn RawText(raw_text: []const u8) Entity {
    return Entity{
        .definition = .{
            .text = .{
                .sanitize = false,
                .value = raw_text,
            },
        },
        .transform = struct {
            fn lambda() []const u8 {
                return raw_text;
            }
        }.lambda,
    };
}
