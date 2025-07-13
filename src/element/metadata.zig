const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;
const VoidElement = base.VoidElement;

pub fn Head(args: anytype) fn (anytype) Entity {
    return Element("head")(args);
}

pub fn Title(args: anytype) fn (anytype) Entity {
    return Element("title")(args);
}

pub fn Base(args: anytype) fn (anytype) Entity {
    return VoidElement("base")(args);
}

pub fn Link(args: anytype) fn (anytype) Entity {
    return VoidElement("link")(args);
}

pub fn Meta(args: anytype) fn (anytype) Entity {
    return VoidElement("meta")(args);
}

pub fn Style(args: anytype) fn (anytype) Entity {
    return Element("style")(args);
}
