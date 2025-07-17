const std = @import("std");
const testing = std.testing;
const html = @import("html");
const transform = html.transform;
const Attribute = html.base.Attribute;
const Element = html.base.Element;
const VoidElement = html.base.VoidElement;
const RawText = html.base.RawText;
const Text = html.base.Text;

test "void element must transform accordingly" {
    const elm1 = VoidElement("br")(.{});
    try testing.expectEqualSlices(u8, "br", elm1.definition.element.name);
    try testing.expect(elm1.definition.element.is_void == true);
    try testing.expect(elm1.definition.element.attributes.len == 0);
    try testing.expect(elm1.definition.element.chlidren.len == 0);
    try testing.expectEqualSlices(u8, "<br>", transform(.{elm1}));

    const elm2 = VoidElement("meta")(.{
        Attribute("charset")("utf-8"),
    });
    try testing.expectEqualSlices(u8, "meta", elm2.definition.element.name);
    try testing.expect(elm2.definition.element.is_void == true);
    try testing.expect(elm2.definition.element.attributes.len == 1);
    try testing.expect(elm2.definition.element.chlidren.len == 0);
    try testing.expectEqualSlices(u8, "<meta charset=\"utf-8\">", transform(.{elm2}));

    const elm3 = VoidElement("input")(.{
        Attribute("type")("number"),
        Attribute("min")("0"),
        Attribute("max")("9"),
    });
    try testing.expectEqualSlices(u8, "input", elm3.definition.element.name);
    try testing.expect(elm3.definition.element.is_void == true);
    try testing.expect(elm3.definition.element.attributes.len == 3);
    try testing.expect(elm3.definition.element.chlidren.len == 0);
    try testing.expectEqualSlices(u8, "<input type=\"number\" min=\"0\" max=\"9\">", transform(.{elm3}));
}

test "normal element must transform accordingly" {
    const elm1 = Element("div")(.{})(.{});
    try testing.expectEqualSlices(u8, "div", elm1.definition.element.name);
    try testing.expect(elm1.definition.element.is_void == false);
    try testing.expect(elm1.definition.element.attributes.len == 0);
    try testing.expect(elm1.definition.element.chlidren.len == 0);
    try testing.expectEqualSlices(u8, "<div></div>", transform(.{elm1}));

    const elm2 = Element("div")(.{
        Attribute("class")("modal"),
    })(.{});
    try testing.expectEqualSlices(u8, "div", elm2.definition.element.name);
    try testing.expect(elm2.definition.element.is_void == false);
    try testing.expect(elm2.definition.element.attributes.len == 1);
    try testing.expect(elm2.definition.element.chlidren.len == 0);
    try testing.expectEqualSlices(u8, "<div class=\"modal\"></div>", transform(.{elm2}));

    const elm3 = Element("ul")(.{
        Element("li"),
        Element("li")(.{Attribute("class")("list")}),
    })(.{});
    try testing.expectEqualSlices(u8, "ul", elm3.definition.element.name);
    try testing.expect(elm3.definition.element.is_void == false);
    try testing.expect(elm3.definition.element.attributes.len == 0);
    try testing.expect(elm3.definition.element.chlidren.len == 2);
    try testing.expectEqualSlices(u8, "<ul><li></li><li class=\"list\"></li></ul>", transform(.{elm3}));

    const elm4 = Element("nav")(.{
        Attribute("class")("navbar"),
    })(.{
        Element("a")(.{Attribute("href")("http://localhost/")})(.{RawText(.{"foo"})}),
        Element("a")(.{Attribute("href")("http://localhost/")})(.{RawText(.{"bar"})}),
    });
    try testing.expectEqualSlices(u8, "nav", elm4.definition.element.name);
    try testing.expect(elm4.definition.element.is_void == false);
    try testing.expect(elm4.definition.element.attributes.len == 1);
    try testing.expect(elm4.definition.element.chlidren.len == 2);
    const expected = "<nav class=\"navbar\"><a href=\"http://localhost/\">foo</a><a href=\"http://localhost/\">bar</a></nav>";
    try testing.expectEqualSlices(u8, expected, transform(.{elm4}));
}

test "text element must transform accordingly" {
    const elm1 = RawText(.{"<p>rawwww</p>"});
    try testing.expectEqualSlices(u8, "<p>rawwww</p>", transform(.{elm1}));
    const elm2 = Text(.{"<p>rawwww</p>"});
    try testing.expectEqualSlices(u8, "&lt;p&gt;rawwww&lt;/p&gt;", transform(.{elm2}));
    const elm3 = Element("div")(.{
        RawText(.{
            "first <b>raw</b> text\n",
            "or is it?",
        }),
    });
    try testing.expectEqualSlices(u8, "<div>first <b>raw</b> text\nor is it?</div>", transform(.{elm3}));
}
