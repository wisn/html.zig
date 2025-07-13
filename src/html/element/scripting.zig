const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;

pub fn Script(args: anytype) fn (anytype) Entity {
    return Element("script")(args);
}

pub fn NoScript(args: anytype) fn (anytype) Entity {
    return Element("noscript")(args);
}

pub fn Template(args: anytype) fn (anytype) Entity {
    return Element("template")(args);
}

pub fn Slot(args: anytype) fn (anytype) Entity {
    return Element("slot")(args);
}

pub fn Canvas(args: anytype) fn (anytype) Entity {
    return Element("canvas")(args);
}

pub fn Svg(args: anytype) fn (anytype) Entity {
    return Element("svg")(args);
}
