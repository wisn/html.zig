const std = @import("std");
const internal = @import("internal");
const transformer = @import("transformer");
const validation = @import("validation");
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
                    const entity = Entity{
                        .definition = .{
                            .element = .{
                                .name = name,
                                .attributes = util.fetch_entity_list(attributes),
                                .chlidren = util.fetch_entity_list(elements),
                            },
                        },
                    };

                    return comptime Entity{
                        .definition = entity.definition,
                        .transform = struct {
                            fn lambda() []const u8 {
                                return transformer.transform(.{entity});
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
            const entity = Entity{
                .definition = .{
                    .element = .{
                        .name = name,
                        .is_void = true,
                        .attributes = util.fetch_entity_list(attributes),
                    },
                },
            };

            return comptime Entity{
                .definition = entity.definition,
                .transform = struct {
                    fn lambda() []const u8 {
                        return transformer.transform(.{entity});
                    }
                }.lambda,
            };
        }
    }.compose_attributes;
}

pub fn RawText(raw_text: []const u8) Entity {
    const entity = Entity{
        .definition = .{
            .text = .{
                .sanitize = false,
                .value = raw_text,
            },
        },
    };
    return comptime Entity{
        .definition = entity.definition,
        .transform = struct {
            fn lambda() []const u8 {
                return transformer.transform(.{entity});
            }
        }.lambda,
    };
}

pub fn Text(text: []const u8) Entity {
    const entity = Entity{
        .definition = .{
            .text = .{
                .sanitize = true,
                .value = text,
            },
        },
    };
    return comptime Entity{
        .definition = entity.definition,
        .transform = struct {
            fn lambda() []const u8 {
                return transformer.transform(.{entity});
            }
        }.lambda,
    };
}
