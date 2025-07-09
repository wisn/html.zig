const std = @import("std");
const ComposeOption = @import("base").composer.ComposeOption;
const DefaultAttributeComposeOptions = @import("base").composer.DefaultAttributeComposeOptions;
const AttributeRenderFn = @import("base").renderer.AttributeRenderFn;
const AttributeRenderOptions = @import("base").renderer.AttributeRenderOptions;
const AttributeNameValidator = @import("validator").attribute.AttributeNameValidator;
const AttributeValueValidator = @import("validator").attribute.AttributeValueValidator;

// Attribute(name)(value)(render options)
// Attribute(name) to build an attribute with no value
// Attribute(name)(value) to build an attribute with both name and value
const AttributeFn = AttributeNameFn;
const AttributeNameFn = fn ([]const u8) AttributeValueFn;
const AttributeValueFn = fn (?[]const u8) AttributeRenderFn;

pub const Attribute = AttributeComposer.compose(DefaultAttributeComposeOptions);

const AttributeComposer = struct {
    fn compose(compose_option: ComposeOption) AttributeFn {
        const name_composer = struct {
            fn compose_name(name: []const u8) AttributeValueFn {
                if (compose_option.attribute.with_validation) {
                    AttributeNameValidator.validate(name);
                }

                const value_composer = struct {
                    fn compose_value(optional_value: ?[]const u8) AttributeRenderFn {
                        if (compose_option.attribute.with_validation) {
                            AttributeValueValidator.validate(optional_value);
                        }

                        const renderer = struct {
                            fn render(render_options: AttributeRenderOptions) []const u8 {
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
