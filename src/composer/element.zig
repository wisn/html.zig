const std = @import("std");
const ComposeOption = @import("base").composer.ComposeOption;
const DefaultElementComposeOptions = @import("base").composer.DefaultElementComposeOptions;
const ElementRenderFn = @import("base").renderer.ElementRenderFn;
const ElementRenderOptions = @import("base").renderer.ElementRenderOptions;
const ElementNameValidator = @import("validator").element.ElementNameValidator;

// Element(name)(attributes)(children)(render options)
// Element(name) to build <name></name>
// Element(name)(attributes) to build <name ...attributes...></name>
// Element(name)(children) to build <nam>...children...</name>
// Element(name)(attributes)(children) to build <name ...attributes...>...children...</name>
// toggle void element option in the compose option to build a special void element such as <br>
const ElementFn = ElementNameFn;
const ElementNameFn = fn ([]const u8) ElementAttributeFn;
const ElementAttributeFn = fn (anytype) ElementChildrenFn;
const ElementChildrenFn = fn (anytype) ElementRenderFn;

pub const Element = ElementComposer.compose(DefaultElementComposeOptions);

const ElementComposer = struct {
    fn compose(compose_option: ComposeOption) ElementFn {
        const name_composer = struct {
            fn compose_name(name: []const u8) ElementAttributeFn {
                if (compose_option.element.with_validation) {
                    ElementNameValidator.validate(name);
                }

                const attribute_composer = struct {
                    fn compose_attribute(attributes: anytype) ElementChildrenFn {
                        var has_attributes = true;
                        const attribute_fields = std.meta.fields(@TypeOf(attributes));

                        if (attribute_fields.len > 0) {
                            const typeName = @typeName(attribute_fields[0].type);
                            const error_message = "InvalidElementConstruct: parameters need to be uniform (either all elements or all attributes)";
                            const max_branches = 22 * typeName.len + 1000;
                            @setEvalBranchQuota(max_branches);

                            if (is_element(typeName)) {
                                for (attribute_fields) |field| {
                                    if (!is_element(@typeName(field.type))) {
                                        @compileError(error_message);
                                    }
                                }
                                has_attributes = false;
                            } else {
                                if (is_attribute(typeName)) {
                                    for (attribute_fields) |field| {
                                        if (!is_attribute(@typeName(field.type))) {
                                            @compileError(error_message);
                                        }
                                    }
                                } else {
                                    @compileError("InvalidElementConstruct: unknown parameter. pass either element or attribute");
                                }
                            }
                        }

                        const children_composer = struct {
                            fn compose_children(children: anytype) fn (ElementRenderOptions) []const u8 {
                                _ = children;

                                const renderer = struct {
                                    fn render(render_options: ElementRenderOptions) []const u8 {
                                        _ = render_options;

                                        const start_tag_open = "<" ++ name;
                                        const start_tag_close = ">";
                                        const end_tag = if (compose_option.element.void_element) "" else "</" ++ name ++ ">";
                                        const element = start_tag_open ++ start_tag_close ++ end_tag;

                                        return element;
                                    }
                                };

                                return renderer.render;
                            }
                        };

                        return children_composer.compose_children;
                    }
                };

                return attribute_composer.compose_attribute;
            }
        };
        return name_composer.compose_name;
    }

    fn is_attribute(typeName: []const u8) bool {
        return std.mem.containsAtLeast(u8, typeName, 1, "AttributeRenderOptions");
    }

    fn is_element(typeName: []const u8) bool {
        return std.mem.containsAtLeast(u8, typeName, 1, "ElementRenderOptions");
    }
};
