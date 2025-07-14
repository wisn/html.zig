const base = @import("base");
const internal = @import("internal");
const validation = @import("validation");
const transformer = internal.transformer;
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

            return comptime Entity{
                .definition = .{
                    .element = .{
                        .name = "html",
                        .attributes = util.fetch_entity_list(attributes),
                        .elements = util.fetch_entity_list(elements),
                    },
                },
                .transform = struct {
                    fn lambda() []const u8 {
                        const doctype = "<!DOCTYPE html>";
                        const tag_start = "<html";
                        const tag_attributes = comptime transformer.transform_attributes(attributes);
                        const tag_close = ">";
                        const tag_children = comptime transformer.transform_elements(elements);
                        const tag_end = "</html>";
                        return doctype ++ tag_start ++ tag_attributes ++ tag_close ++ tag_children ++ tag_end;
                    }
                }.lambda,
            };
        }
    }.compose_children;
}

pub fn Comment(comment: []const u8) Entity {
    return comptime Entity{
        .definition = .{
            .comment = .{
                .value = comment,
            },
        },
        .transform = struct {
            fn lambda() []const u8 {
                const tag_start = "<!-- ";
                const tag_end = " -->";
                return tag_start ++ comment ++ tag_end;
            }
        }.lambda,
    };
}
