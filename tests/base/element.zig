const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Attribute = html.base.Attribute;
const Element = html.base.Element;
const VoidElement = html.base.VoidElement;
const Text = html.base.Text;

test "void element must transform accordingly" {
    const elm1 = VoidElement("br")(.{});
    try testing.expectEqualSlices(u8, "<br>", elm1.transform());
    const elm2 = VoidElement("meta")(.{
        Attribute("charset")("utf-8"),
    });
    try testing.expectEqualSlices(u8, "<meta charset=\"utf-8\">", elm2.transform());
    const elm3 = VoidElement("input")(.{
        Attribute("type")("number"),
        Attribute("min")("0"),
        Attribute("max")("9"),
    });
    try testing.expectEqualSlices(u8, "<input type=\"number\" min=\"0\" max=\"9\">", elm3.transform());
}

test "normal element must transform accordingly" {
    const elm1 = Element("div")(.{})(.{});
    try testing.expectEqualSlices(u8, "<div></div>", elm1.transform());
    const elm2 = Element("div")(.{
        Attribute("class")("modal"),
    })(.{});
    try testing.expectEqualSlices(u8, "<div class=\"modal\"></div>", elm2.transform());
    const elm3 = Element("ul")(.{
        Element("li"),
        Element("li")(.{Attribute("class")("list")}),
    })(.{});
    try testing.expectEqualSlices(u8, "<ul><li></li><li class=\"list\"></li></ul>", elm3.transform());
    const elm4 = Element("nav")(.{
        Attribute("class")("navbar"),
    })(.{
        Element("a")(.{Attribute("href")("http://localhost/")})(.{Text("foo")}),
        Element("a")(.{Attribute("href")("http://localhost/")})(.{Text("bar")}),
    });
    try testing.expectEqualSlices(u8, "<nav class=\"navbar\"><a href=\"http://localhost/\">foo</a><a href=\"http://localhost/\">bar</a></nav>", elm4.transform());
}
