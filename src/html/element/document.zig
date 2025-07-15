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
    const attributes = if (has_attributes) args else .{};

    return struct {
        fn compose_children(children: anytype) Entity {
            validation.base.element.validate_elements(children);
            const elements = if (has_attributes) children else args;
            const entity = Entity{
                .definition = .{
                    .element = .{
                        .name = "html",
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

pub fn Comment(comment: []const u8) Entity {
    const entity = Entity{
        .definition = .{
            .comment = .{
                .value = comment,
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
