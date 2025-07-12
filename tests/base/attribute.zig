const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Attribute = html.base.Attribute;
const DataAttribute = html.base.DataAttribute;
const InteractiveAttribute = html.base.InteractiveAttribute;

test "attribute without value (boolean attribute) must transform accordingly" {
    try testing.expectEqualSlices(u8, "disabled", Attribute("disabled")(null).transform());
}

test "attribute with value must transform accordingly" {
    try testing.expectEqualSlices(u8, "class=\"button\"", Attribute("class")("button").transform());
}

test "data attribute must transform accordingly" {
    try testing.expectEqualSlices(u8, "data-foo=\"bar\"", DataAttribute("foo")("bar").transform());
}

test "interactive attribute must transform accordingly" {
    try testing.expectEqualSlices(u8, "aria-foo=\"bar\"", InteractiveAttribute("foo")("bar").transform());
}
