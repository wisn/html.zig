const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;
const VoidElement = base.VoidElement;

pub fn P(args: anytype) fn (anytype) Entity {
    return Element("p")(args);
}

pub fn Hr(args: anytype) Entity {
    return VoidElement("hr")(args);
}

pub fn Pre(args: anytype) fn (anytype) Entity {
    return Element("pre")(args);
}

pub fn BlockQuote(args: anytype) fn (anytype) Entity {
    return Element("blockquote")(args);
}

pub fn Ol(args: anytype) fn (anytype) Entity {
    return Element("ol")(args);
}

pub fn Ul(args: anytype) fn (anytype) Entity {
    return Element("ul")(args);
}

pub fn Menu(args: anytype) fn (anytype) Entity {
    return Element("menu")(args);
}

pub fn Li(args: anytype) fn (anytype) Entity {
    return Element("li")(args);
}

pub fn Dl(args: anytype) fn (anytype) Entity {
    return Element("dl")(args);
}

pub fn Dt(args: anytype) fn (anytype) Entity {
    return Element("dt")(args);
}

pub fn Dd(args: anytype) fn (anytype) Entity {
    return Element("dd")(args);
}

pub fn Figure(args: anytype) fn (anytype) Entity {
    return Element("figure")(args);
}

pub fn FigCaption(args: anytype) fn (anytype) Entity {
    return Element("figcaption")(args);
}

pub fn Main(args: anytype) fn (anytype) Entity {
    return Element("main")(args);
}

pub fn Search(args: anytype) fn (anytype) Entity {
    return Element("search")(args);
}

pub fn Div(args: anytype) fn (anytype) Entity {
    return Element("div")(args);
}
