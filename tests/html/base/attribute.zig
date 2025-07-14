const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Attribute = html.base.Attribute;
const DataAttribute = html.base.DataAttribute;
const InteractiveAttribute = html.base.InteractiveAttribute;

test "attribute without value (boolean attribute) must transform accordingly" {
    const attribute = Attribute("disabled")(null);
    try testing.expectEqualSlices(u8, "disabled", attribute.definition.attribute.name);
    try testing.expect(attribute.definition.attribute.value == null);
    try testing.expectEqualSlices(u8, "disabled", attribute.transform());
}

test "attribute with value must transform accordingly" {
    const attribute = Attribute("class")("button");
    try testing.expectEqualSlices(u8, "class", attribute.definition.attribute.name);
    try testing.expectEqualSlices(u8, "button", attribute.definition.attribute.value.?);
    try testing.expectEqualSlices(u8, "class=\"button\"", attribute.transform());
}

test "data attribute must transform accordingly" {
    const attribute = DataAttribute("foo")("bar");
    try testing.expectEqualSlices(u8, "data-foo", attribute.definition.attribute.name);
    try testing.expectEqualSlices(u8, "bar", attribute.definition.attribute.value.?);
    try testing.expectEqualSlices(u8, "data-foo=\"bar\"", attribute.transform());
}

test "interactive attribute must transform accordingly" {
    const attribute = InteractiveAttribute("foo")("bar");
    try testing.expectEqualSlices(u8, "aria-foo", attribute.definition.attribute.name);
    try testing.expectEqualSlices(u8, "bar", attribute.definition.attribute.value.?);
    try testing.expectEqualSlices(u8, "aria-foo=\"bar\"", attribute.transform());
}
