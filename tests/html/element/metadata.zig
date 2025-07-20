const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Attribute = html.base.Attribute;
const Text = html.base.Text;
const Base = html.element.Base;
const Link = html.element.Link;
const Meta = html.element.Meta;
const Style = html.element.Style;

test "base element must transform accordingly" {
    const elm = Base(.{Attribute("href")("http://localhost/")});
    try testing.expectEqualSlices(u8, "<base href=\"http://localhost/\">", elm.transform());
}

test "link element must transform accordingly" {
    const elm = Link(.{
        Attribute("rel")("stylesheet"),
        Attribute("href")("http://localhost/style.css"),
    });
    try testing.expectEqualSlices(u8, "<link rel=\"stylesheet\" href=\"http://localhost/style.css\">", elm.transform());
}

test "meta element must transform accordingly" {
    const elm = Meta(.{Attribute("charset")("utf-8")});
    try testing.expectEqualSlices(u8, "<meta charset=\"utf-8\">", elm.transform());
}

test "style element must transform accordingly" {
    const elm = Style(.{Attribute("type")("text/css")})(.{Text(.{
        "body { cursor: default; }",
    })});
    try testing.expectEqualSlices(u8, "<style type=\"text/css\">body { cursor: default; }</style>", elm.transform());
}
