const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;

pub fn Ins(args: anytype) fn (anytype) Entity {
    return Element("ins")(args);
}

pub fn Del(args: anytype) fn (anytype) Entity {
    return Element("del")(args);
}
