const base = @import("base");
const internal = @import("internal");
const transformer = @import("transformer");
const validation = @import("validation");
const util = internal.util;
const Entity = internal.entity.Entity;
const Element = base.Element;

pub fn Html(args: anytype) fn (anytype) Entity {
    comptime var has_attributes = true;
    validation.base.element.validate_arguments(args, &has_attributes);
    const element_name = "html";
    const validated_attributes = if (has_attributes) util.fetch_entity_list(args) else []Entity{};
    validation.attribute.validate_attributes(element_name, &validated_attributes);

    return struct {
        fn compose_children(children: anytype) Entity {
            validation.base.element.validate_elements(children);
            const validated_children = if (has_attributes) util.fetch_entity_list(children) else util.fetch_entity_list(args);
            validation.element.validate_children(element_name, &validated_children);
            const entity = Entity{
                .definition = .{
                    .element = .{
                        .name = element_name,
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

pub fn Comment(comment: []const u8) Entity {
    const entity = Entity{
        .definition = .{
            .comment = .{
                .value = comment,
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
