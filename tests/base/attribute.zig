const std = @import("std");
const testing = std.testing;
const Attribute = @import("html").Attribute;

test "valid attribute must render correctly" {
    try testing.expectEqualSlices(u8, "disabled", Attribute("disabled")(null)(.{}));
    try testing.expectEqualSlices(u8, "data-random=\"\"", Attribute("data-random")("")(.{}));
    try testing.expectEqualSlices(u8, "lang=\"en\"", Attribute("lang")("en")(.{}));
    try testing.expectEqualSlices(u8, "data=\"&amp;\"", Attribute("data")("&amp;")(.{}));
    try testing.expectEqualSlices(u8, "data=\"&this-should-be-valid\"", Attribute("data")("&this-should-be-valid")(.{}));
    try testing.expectEqualSlices(u8, "data=\"this-should-&be-valid\"", Attribute("data")("this-should-&be-valid")(.{}));
    try testing.expectEqualSlices(u8, "data=\"this-should-be-valid&\"", Attribute("data")("this-should-be-valid&")(.{}));
}
