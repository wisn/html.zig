const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;
const VoidElement = base.VoidElement;

pub fn A(args: anytype) fn (anytype) Entity {
    return Element("a")(args);
}

pub fn Em(args: anytype) fn (anytype) Entity {
    return Element("em")(args);
}

pub fn Strong(args: anytype) fn (anytype) Entity {
    return Element("strong")(args);
}

pub fn Small(args: anytype) fn (anytype) Entity {
    return Element("small")(args);
}

pub fn S(args: anytype) fn (anytype) Entity {
    return Element("s")(args);
}

pub fn Cite(args: anytype) fn (anytype) Entity {
    return Element("cite")(args);
}

pub fn Q(args: anytype) fn (anytype) Entity {
    return Element("q")(args);
}

pub fn Dfn(args: anytype) fn (anytype) Entity {
    return Element("dfn")(args);
}

pub fn Abbr(args: anytype) fn (anytype) Entity {
    return Element("abbr")(args);
}

pub fn Ruby(args: anytype) fn (anytype) Entity {
    return Element("ruby")(args);
}

pub fn Rt(args: anytype) fn (anytype) Entity {
    return Element("rt")(args);
}

pub fn Rp(args: anytype) fn (anytype) Entity {
    return Element("rp")(args);
}

pub fn Data(args: anytype) fn (anytype) Entity {
    return Element("data")(args);
}

pub fn Time(args: anytype) fn (anytype) Entity {
    return Element("time")(args);
}

pub fn Code(args: anytype) fn (anytype) Entity {
    return Element("code")(args);
}

pub fn Var(args: anytype) fn (anytype) Entity {
    return Element("var")(args);
}

pub fn Samp(args: anytype) fn (anytype) Entity {
    return Element("samp")(args);
}

pub fn Kbd(args: anytype) fn (anytype) Entity {
    return Element("kbd")(args);
}

pub fn Sub(args: anytype) fn (anytype) Entity {
    return Element("sub")(args);
}

pub fn Sup(args: anytype) fn (anytype) Entity {
    return Element("sup")(args);
}

pub fn I(args: anytype) fn (anytype) Entity {
    return Element("i")(args);
}

pub fn B(args: anytype) fn (anytype) Entity {
    return Element("b")(args);
}

pub fn U(args: anytype) fn (anytype) Entity {
    return Element("u")(args);
}

pub fn Mark(args: anytype) fn (anytype) Entity {
    return Element("mark")(args);
}

pub fn Bdi(args: anytype) fn (anytype) Entity {
    return Element("bdi")(args);
}

pub fn Bdo(args: anytype) fn (anytype) Entity {
    return Element("bdo")(args);
}

pub fn Span(args: anytype) fn (anytype) Entity {
    return Element("span")(args);
}

pub fn Br(args: anytype) Entity {
    return VoidElement("br")(args);
}

pub fn Wbr(args: anytype) Entity {
    return VoidElement("wbr")(args);
}
