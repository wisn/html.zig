const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;

pub fn Details(args: anytype) fn (anytype) Entity {
    return Element("details")(args);
}

pub fn Summary(args: anytype) fn (anytype) Entity {
    return Element("summary")(args);
}
