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
            const validated_attributes = if (has_attributes) util.fetch_entity_list(args) else util.fetch_entity_list(.{});
            validation.attribute.validate_attributes(name, &validated_attributes);

            return struct {
                fn compose_children(children: anytype) Entity {
                    validation.base.element.validate_elements(children);
                    const validated_children = if (has_attributes) util.fetch_entity_list(children) else util.fetch_entity_list(args);
                    validation.element.validate_children(name, &validated_children);
                    const entity = Entity{
                        .definition = .{
                            .element = .{
                                .name = name,
                                .attributes = validated_attributes,
                                .chlidren = validated_children,
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
            }.compose_children;
        }
    }.closure;
}

pub fn VoidElement(name: []const u8) fn (anytype) Entity {
    validation.base.element.validate_name(name);
    return struct {
        fn compose_attributes(attributes: anytype) Entity {
            validation.base.element.validate_attributes(attributes);
            const validated_attributes = util.fetch_entity_list(attributes);
            validation.attribute.validate_attributes(name, &validated_attributes);
            const entity = Entity{
                .definition = .{
                    .element = .{
                        .name = name,
                        .is_void = true,
                        .attributes = validated_attributes,
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
    }.compose_attributes;
}
