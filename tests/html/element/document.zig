const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Attribute = html.base.Attribute;
const RawText = html.base.RawText;
const Comment = html.element.Comment;
const Html = html.element.Html;
const Head = html.element.Head;
const Title = html.element.Title;
const Meta = html.element.Meta;
const Body = html.element.Body;
const H1 = html.element.H1;

test "comment element must transform accordingly" {
    const elm = Comment("this is a simple comment");
    try testing.expectEqualSlices(u8, "<!-- this is a simple comment -->", elm.transform());
}

test "html element must transform accordingly" {
    const elm = Html(.{Attribute("lang")("en")})(.{
        Head(.{
            Title(.{RawText("html5")}),
            Meta(.{Attribute("charset")("utf-8")}),
        }),
        Body(.{
            H1(.{RawText("html5")}),
        }),
    });
    const expected = "<!DOCTYPE html><html lang=\"en\"><head><title>html5</title><meta charset=\"utf-8\"></head><body><h1>html5</h1></body></html>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}
