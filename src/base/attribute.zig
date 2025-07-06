const std = @import("std");
const RenderFn = @import("renderer.zig").RenderFn;
const RenderOptions = @import("renderer.zig").RenderOptions;
const AttributeNameValidator = @import("validator").attribute.AttributeNameValidator;
const AttributeValueValidator = @import("validator").attribute.AttributeValueValidator;

// Attribute(name)(value)(render options)
// Attribute(name) to build an attribute with no value
// Attribute(name)(value) to build an attribute with both name and value
const AttributeFn = AttributeNameFn;
const AttributeNameFn = fn ([]const u8) AttributeValueFn;
const AttributeValueFn = fn (?[]const u8) RenderFn;

pub const Attribute = AttributeBuilder.build();

const AttributeBuilder = struct {
    fn build() AttributeFn {
        const name_builder = struct {
            fn build_name(name: []const u8) AttributeValueFn {
                AttributeNameValidator.validate(name);
                const value_builder = struct {
                    fn build_value(value: ?[]const u8) RenderFn {
                        AttributeValueValidator.validate(value);
                        const renderer = struct {
                            fn render(options: RenderOptions) []const u8 {
                                _ = options;
                                if (value) |attrValue| {
                                    return name ++ "=\"" ++ attrValue ++ "\"";
                                }
                                return name;
                            }
                        };
                        return renderer.render;
                    }
                };
                return value_builder.build_value;
            }
        };
        return name_builder.build_name;
    }
};
