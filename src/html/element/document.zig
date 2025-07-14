const base = @import("base");
const internal = @import("internal");
const transformer = internal.transformer;
const validator = internal.validator;
const Entity = internal.entity.Entity;
const Element = base.Element;

pub fn Html(args: anytype) fn (anytype) Entity {
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
                        .name = "html",
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
    return Entity{
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
