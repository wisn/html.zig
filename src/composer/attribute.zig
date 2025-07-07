const std = @import("std");
const ComposeOption = @import("base").composer.ComposeOption;
const RenderFn = @import("base").renderer.RenderFn;
const RenderOptions = @import("base").renderer.RenderOptions;
const AttributeNameValidator = @import("validator").attribute.AttributeNameValidator;
const AttributeValueValidator = @import("validator").attribute.AttributeValueValidator;

// Attribute(name)(value)(render options)
// Attribute(name) to build an attribute with no value
// Attribute(name)(value) to build an attribute with both name and value
const AttributeFn = AttributeNameFn;
const AttributeNameFn = fn ([]const u8) AttributeValueFn;
const AttributeValueFn = fn (?[]const u8) RenderFn;

pub const Attribute = AttributeComposer.compose(.{});

const AttributeComposer = struct {
    fn compose(compose_option: ComposeOption) AttributeFn {
        _ = compose_option;
        const name_composer = struct {
            fn compose_name(name: []const u8) AttributeValueFn {
                AttributeNameValidator.validate(name);
                const value_composer = struct {
                    fn compose_value(optional_value: ?[]const u8) RenderFn {
                        AttributeValueValidator.validate(optional_value);
                        const renderer = struct {
                            fn render(render_options: RenderOptions) []const u8 {
                                _ = render_options;
                                if (optional_value) |value| {
                                    return name ++ "=\"" ++ value ++ "\"";
                                }
                                return name;
                            }
                        };
                        return renderer.render;
                    }
                };
                return value_composer.compose_value;
            }
        };
        return name_composer.compose_name;
    }
};
