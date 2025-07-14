const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Attribute = html.base.Attribute;
const Element = html.base.Element;
const VoidElement = html.base.VoidElement;
const RawText = html.base.RawText;

test "void element must transform accordingly" {
    const elm1 = VoidElement("br")(.{});
    try testing.expectEqualSlices(u8, "br", elm1.definition.element.name);
    try testing.expect(elm1.definition.element.is_void == true);
    try testing.expect(elm1.definition.element.attributes.len == 0);
    try testing.expect(elm1.definition.element.elements.len == 0);
    try testing.expectEqualSlices(u8, "<br>", elm1.transform());

    const elm2 = VoidElement("meta")(.{
        Attribute("charset")("utf-8"),
    });
    try testing.expectEqualSlices(u8, "meta", elm2.definition.element.name);
    try testing.expect(elm2.definition.element.is_void == true);
    try testing.expect(elm2.definition.element.attributes.len == 1);
    try testing.expect(elm2.definition.element.elements.len == 0);
    try testing.expectEqualSlices(u8, "<meta charset=\"utf-8\">", elm2.transform());

    const elm3 = VoidElement("input")(.{
        Attribute("type")("number"),
        Attribute("min")("0"),
        Attribute("max")("9"),
    });
    try testing.expectEqualSlices(u8, "input", elm3.definition.element.name);
    try testing.expect(elm3.definition.element.is_void == true);
    try testing.expect(elm3.definition.element.attributes.len == 3);
    try testing.expect(elm3.definition.element.elements.len == 0);
    try testing.expectEqualSlices(u8, "<input type=\"number\" min=\"0\" max=\"9\">", elm3.transform());
}

test "normal element must transform accordingly" {
    const elm1 = Element("div")(.{})(.{});
    try testing.expectEqualSlices(u8, "div", elm1.definition.element.name);
    try testing.expect(elm1.definition.element.is_void == false);
    try testing.expect(elm1.definition.element.attributes.len == 0);
    try testing.expect(elm1.definition.element.elements.len == 0);
    try testing.expectEqualSlices(u8, "<div></div>", elm1.transform());

    const elm2 = Element("div")(.{
        Attribute("class")("modal"),
    })(.{});
    try testing.expectEqualSlices(u8, "div", elm2.definition.element.name);
    try testing.expect(elm2.definition.element.is_void == false);
    try testing.expect(elm2.definition.element.attributes.len == 1);
    try testing.expect(elm2.definition.element.elements.len == 0);
    try testing.expectEqualSlices(u8, "<div class=\"modal\"></div>", elm2.transform());

    const elm3 = Element("ul")(.{
        Element("li"),
        Element("li")(.{Attribute("class")("list")}),
    })(.{});
    try testing.expectEqualSlices(u8, "ul", elm3.definition.element.name);
    try testing.expect(elm3.definition.element.is_void == false);
    try testing.expect(elm3.definition.element.attributes.len == 0);
    try testing.expect(elm3.definition.element.elements.len == 2);
    try testing.expectEqualSlices(u8, "<ul><li></li><li class=\"list\"></li></ul>", elm3.transform());

    const elm4 = Element("nav")(.{
        Attribute("class")("navbar"),
    })(.{
        Element("a")(.{Attribute("href")("http://localhost/")})(.{RawText("foo")}),
        Element("a")(.{Attribute("href")("http://localhost/")})(.{RawText("bar")}),
    });
    try testing.expectEqualSlices(u8, "nav", elm4.definition.element.name);
    try testing.expect(elm4.definition.element.is_void == false);
    try testing.expect(elm4.definition.element.attributes.len == 1);
    try testing.expect(elm4.definition.element.elements.len == 2);
    try testing.expectEqualSlices(u8, "<nav class=\"navbar\"><a href=\"http://localhost/\">foo</a><a href=\"http://localhost/\">bar</a></nav>", elm4.transform());
}
