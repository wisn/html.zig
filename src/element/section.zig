const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;

pub fn Body(args: anytype) fn (anytype) Entity {
    return Element("body")(args);
}

pub fn Article(args: anytype) fn (anytype) Entity {
    return Element("article")(args);
}

pub fn Section(args: anytype) fn (anytype) Entity {
    return Element("section")(args);
}

pub fn Nav(args: anytype) fn (anytype) Entity {
    return Element("nav")(args);
}

pub fn Aside(args: anytype) fn (anytype) Entity {
    return Element("aside")(args);
}

pub fn H1(args: anytype) fn (anytype) Entity {
    return Element("h1")(args);
}

pub fn H2(args: anytype) fn (anytype) Entity {
    return Element("h2")(args);
}

pub fn H3(args: anytype) fn (anytype) Entity {
    return Element("h3")(args);
}

pub fn H4(args: anytype) fn (anytype) Entity {
    return Element("h4")(args);
}

pub fn H5(args: anytype) fn (anytype) Entity {
    return Element("h5")(args);
}

pub fn H6(args: anytype) fn (anytype) Entity {
    return Element("h6")(args);
}

pub fn Hgroup(args: anytype) fn (anytype) Entity {
    return Element("hgroup")(args);
}

pub fn Header(args: anytype) fn (anytype) Entity {
    return Element("header")(args);
}

pub fn Footer(args: anytype) fn (anytype) Entity {
    return Element("footer")(args);
}

pub fn Address(args: anytype) fn (anytype) Entity {
    return Element("address")(args);
}
