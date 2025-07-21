const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Text = html.base.Text;
const Attribute = html.base.Attribute;
const Body = html.element.Body;
const Article = html.element.Article;
const Section = html.element.Section;
const Nav = html.element.Nav;
const Aside = html.element.Aside;
const H1 = html.element.H1;
const H2 = html.element.H2;
const H3 = html.element.H3;
const H4 = html.element.H4;
const H5 = html.element.H5;
const H6 = html.element.H6;
const A = html.element.A;

test "body element must transform accordingly" {
    const elm = Body(.{})(.{
        H1(.{Text(.{"hello!"})}),
    });
    try testing.expectEqualSlices(u8, "<body><h1>hello!</h1></body>", elm.transform());
}

test "article element must transform accordingly" {
    const elm = Article(.{})(.{
        H2(.{Text(.{"hello!"})}),
    });
    try testing.expectEqualSlices(u8, "<article><h2>hello!</h2></article>", elm.transform());
}

test "section element must transform accordingly" {
    const elm = Section(.{})(.{
        H3(.{Text(.{"hello!"})}),
    });
    try testing.expectEqualSlices(u8, "<section><h3>hello!</h3></section>", elm.transform());
}

test "nav element must transform accordingly" {
    const elm = Nav(.{Attribute("class")("navbar")})(.{
        A(.{Attribute("href")("http://localhost/")})(.{Text(.{"foo"})}),
        A(.{Attribute("href")("http://localhost/")})(.{Text(.{"bar"})}),
    });
    const expected = "<nav class=\"navbar\"><a href=\"http://localhost/\">foo</a><a href=\"http://localhost/\">bar</a></nav>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "aside element must transform accordingly" {
    const elm = Aside(.{})(.{
        H4(.{Text(.{"hello!"})}),
    });
    try testing.expectEqualSlices(u8, "<aside><h4>hello!</h4></aside>", elm.transform());
}

test "heading element must transform accordingly" {
    const elm = Body(.{})(.{
        H5(.{Text(.{"hello!"})}),
        H6(.{Text(.{"world!"})}),
    });
    try testing.expectEqualSlices(u8, "<body><h5>hello!</h5><h6>world!</h6></body>", elm.transform());
}
