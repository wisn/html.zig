const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Attribute = html.base.Attribute;
const Base = html.element.Base;

test "base element must transform accordingly" {
    const elm = Base(.{Attribute("href")("http://localhost/")});
    try testing.expectEqualSlices(u8, "<base href=\"http://localhost/\">", elm.transform());
}
