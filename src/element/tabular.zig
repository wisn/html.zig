const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;
const VoidElement = base.VoidElement;

pub fn Table(args: anytype) fn (anytype) Entity {
    return Element("table")(args);
}

pub fn Caption(args: anytype) fn (anytype) Entity {
    return Element("caption")(args);
}

pub fn ColGroup(args: anytype) fn (anytype) Entity {
    return Element("colgroup")(args);
}

pub fn Col(args: anytype) Entity {
    return VoidElement("col")(args);
}

pub fn Tbody(args: anytype) fn (anytype) Entity {
    return Element("tbody")(args);
}

pub fn Thead(args: anytype) fn (anytype) Entity {
    return Element("thead")(args);
}

pub fn Tfoot(args: anytype) fn (anytype) Entity {
    return Element("tfoot")(args);
}

pub fn Tr(args: anytype) fn (anytype) Entity {
    return Element("tr")(args);
}

pub fn Td(args: anytype) fn (anytype) Entity {
    return Element("td")(args);
}

pub fn Th(args: anytype) fn (anytype) Entity {
    return Element("th")(args);
}
