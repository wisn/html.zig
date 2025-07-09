const std = @import("std");
const testing = std.testing;
const Element = @import("html").Element;

test "element with no attribute & children must render correctly" {
    try testing.expectEqualSlices(u8, "<code></code>", Element("code")(.{})(.{})(.{}));
    const elements = Element("div")(.{
        Element("p"),
        Element("p")(.{}),
        Element("p")(.{})(.{}),
    });
    _ = elements;
}
