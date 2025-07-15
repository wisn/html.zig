const std = @import("std");
const internal = @import("internal");
const validation = @import("validation");
const transformer = internal.transformer;
const util = internal.util;
const Entity = internal.entity.Entity;

pub fn Element(name: []const u8) fn (anytype) (fn (anytype) Entity) {
    validation.base.element.validate_name(name);
    return struct {
        fn closure(args: anytype) fn (anytype) Entity {
            comptime var has_attributes = true;
            validation.base.element.validate_arguments(args, &has_attributes);
            const attributes = if (has_attributes) args else .{};

            return struct {
                fn compose_children(children: anytype) Entity {
                    validation.base.element.validate_elements(children);
                    const elements = if (has_attributes) children else args;

                    return comptime Entity{
                        .definition = .{
                            .element = .{
                                .name = name,
                                .attributes = util.fetch_entity_list(attributes),
                                .chlidren = util.fetch_entity_list(elements),
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
    validation.base.element.validate_name(name);
    return struct {
        fn compose_attributes(attributes: anytype) Entity {
            validation.base.element.validate_attributes(attributes);
            return comptime Entity{
                .definition = .{
                    .element = .{
                        .name = name,
                        .is_void = true,
                        .attributes = util.fetch_entity_list(attributes),
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
    return comptime Entity{
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
