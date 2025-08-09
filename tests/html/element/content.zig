const std = @import("std");
const testing = std.testing;
const html = @import("html");
const Text = html.base.Text;
const Attribute = html.base.Attribute;
const P = html.element.P;
const Hr = html.element.Hr;
const Pre = html.element.Pre;
const BlockQuote = html.element.BlockQuote;
const Ol = html.element.Ol;
const Ul = html.element.Ul;
const Menu = html.element.Menu;
const Li = html.element.Li;
const Dl = html.element.Dl;
const Dt = html.element.Dt;
const Dd = html.element.Dd;
const FigCaption = html.element.FigCaption;
const Main = html.element.Main;
const Search = html.element.Search;
const B = html.element.B;
const Div = html.element.Div;

test "p element must transform accordingly" {
    const elm = P(.{})(.{
        Text(.{"hello, "}),
        B(.{Text(.{"world"})}),
        Text(.{"!"}),
    });
    const expected = "<p>hello, <b>world</b>!</p>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "hr element must transform accordingly" {
    const elm = Hr(.{Attribute("class")("line")});
    const expected = "<hr class=\"line\">";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "pre element must transform accordingly" {
    const elm = Pre(.{Attribute("class")("raw-code")})(.{Text(.{"whatever this is"})});
    const expected = "<pre class=\"raw-code\">whatever this is</pre>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "blockquote element must transform accordingly" {
    const elm = BlockQuote(.{Attribute("cite")("http://localhost/")})(.{
        P(.{Text(.{"add some cool quote here"})}),
    });
    const expected = "<blockquote cite=\"http://localhost/\"><p>add some cool quote here</p></blockquote>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "ol element must transform accordingly" {
    const elm = Ol(.{Attribute("reversed")})(.{
        Li(.{Text(.{"first"})}),
        Li(.{Text(.{"second"})}),
    });
    const expected = "<ol reversed><li>first</li><li>second</li></ol>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "ul element must transform accordingly" {
    const elm = Ul(.{})(.{
        Li(.{Text(.{"first"})}),
        Li(.{Text(.{"second"})}),
    });
    const expected = "<ul><li>first</li><li>second</li></ul>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "menu element must transform accordingly" {
    const elm = Menu(.{})(.{
        Li(.{Text(.{"first"})}),
        Li(.{Text(.{"second"})}),
    });
    const expected = "<menu><li>first</li><li>second</li></menu>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

// test li element

test "dl element must transform accordingly" {
    const elm1 = Dl(.{})(.{
        Dt(.{Text(.{"first group"})}),
        Dd(.{Text(.{"content x"})}),
        Dd(.{Text(.{"content y"})}),
    });
    const expected1 = "<dl><dt>first group</dt><dd>content x</dd><dd>content y</dd></dl>";
    try testing.expectEqualSlices(u8, expected1, elm1.transform());

    const elm2 = Dl(.{})(.{
        Div(.{
            Dt(.{Text(.{"first group"})}),
            Dd(.{Text(.{"content x"})}),
            Dd(.{Text(.{"content y"})}),
        }),
    });
    const expected2 = "<dl><div><dt>first group</dt><dd>content x</dd><dd>content y</dd></div></dl>";
    try testing.expectEqualSlices(u8, expected2, elm2.transform());
}

// test dt element

test "dd element must transform accordingly" {
    const elm = Dd(.{Attribute("class")("pronunciation")})(.{
        Text(.{"/ˈhæpinəs/"}),
    });
    const expected = "<dd class=\"pronunciation\">/ˈhæpinəs/</dd>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

// test figure element

test "figcaption element must transform accordingly" {
    const elm = FigCaption(.{})(.{
        P(.{Text(.{"A duck."})}),
    });
    const expected = "<figcaption><p>A duck.</p></figcaption>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "main element must transform accordingly" {
    const elm = Main(.{})(.{
        P(.{Text(.{"yeah"})}),
    });
    const expected = "<main><p>yeah</p></main>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

test "search element must transform accordingly" {
    const elm = Search(.{})(.{
        P(.{Text(.{"look for something?"})}),
    });
    const expected = "<search><p>look for something?</p></search>";
    try testing.expectEqualSlices(u8, expected, elm.transform());
}

// test div element
