const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Text = html.base.Text;
const Attribute = html.base.Attribute;
const P = html.element.P;
const B = html.element.B;

test "p element must transform accordingly" {
    const elm = P(.{})(.{
        Text(.{"hello, "}),
        B(.{Text(.{"world"})}),
        Text(.{"!"}),
    });
    const expected = "<p>hello, <b>world</b>!</p>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}
