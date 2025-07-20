# html.zig

Build a standard-compliant HTML in Zig!

> [!WARNING]
> This project is not yet stable. The provided APIs may change in the future.
> Production usage is not encouraged at the moment.

## Motivation

I'm planning to build a product written fully in Zig.

One of the things that I need to do is to create a website for it.

Meaning that I need to work with HTML.

While I'm at it, I want to write a standard-compliant HTML.

What if I write the HTML part in Zig too?

What if I force myself to write a standard-compliant HTML?

How to enforce it?

Well, if what I write does not follow the standard, then it will result in a compile error.

Let's leverage the comptime feature of Zig!

## Usage

### Add Dependency

Since there is no release just yet.
We can use the commit hash in the dependency URL.
First, add the following lines in your `build.zig.zon` file.

```zig
.{
    // ...
    .dependencies = .{
        // ...
        .html = .{
            .url = "https://github.com/wisn/html.zig/archive/<commit hash>.tar.gz",
        },
    }
    // ...
}
```

Change the `<commit hash>` slug into your target commit.
For example, let's say the target commit is `3060f0297369efc6b428270db128b62a7c4059fa`.
Thus, the URL will be `https://github.com/wisn/html.zig/archive/3060f0297369efc6b428270db128b62a7c4059fa.tar.gz`.

Second, try to run `zig build` first.
You will get an error message, explaining that the hash field is missing.
Zig will give you the hash. We can just use it!
Finally, the `build.zig.zon` will look like this below.

```zig
.{
    // ...
    .dependencies = .{
        // ...
        .html = .{
            .url = "https://github.com/wisn/html.zig/archive/3060f0297369efc6b428270db128b62a7c4059fa.tar.gz",
            .hash = "html-0.1.0-H8FZYgB7AQD4dvpUols_RejbBRRV76P8U5eGag4o-E0k",
        },
    }
    // ...
}
```

### Update Build File

Next, we need to explicitly add our dependency in the `build.zig` file.
Add these following lines above your main module.

```zig
const html = b.dependency("html", .{
    .target = target,
    .optimize = optimize,
}).module("html");
```

Then, add the module above as an import for our main module.

```zig
<main_module>.addImport("html", html);
```

Change the `<main_module>` slug to your module name.
For example, if your Zig project is following the freshly generated build structure, `exe_mod` should be the main executable module.
Thus, the final line will look like this below.

```zig
exe_mod.addImport("html", html);
```

### Build HTML in Your Project

I will use the following lines as an example. Let's say write these in the `main.zig` file.

```zig
const html = @import("html");
const Attribute = html.base.Attribute;
const Text = html.base.Text;
const Html = html.element.Html;
const Head = html.element.Head;
const Body = html.element.Body;
const H1 = html.element.H1;

pub fn main() void {
    const elm = Html(.{Attribute("lang")("en")})(.{
        Head,
        Body(.{
            H1(.{Text(.{"Hello, world!"})}),
        }),
    });
    std.debug.print(elm.transform() ++ "\n", .{});
}
```

When we run the `zig build run` command, it will print the following text.

```html
<!DOCTYPE html><html lang="en"><head></head><body><h1>Hello, world!</h1></body></html>
```

Now, enjoy building a (soon-to-be) standard-compliant HTML in Zig!
Invalid HTML = compile error!

## Roadmap

<details>
<summary>TODO</summary>

- [x] building blocks
  - [x] attribute
  - [x] data attribute
  - [x] interactive attribute
  - [x] element
  - [x] void element
  - [x] raw text
- [x] element construct
  - [x] comment tag
  - [x] html tag
  - [x] head tag
  - [x] meta tag
  - [x] title tag
  - [x] base tag
  - [x] link tag
  - [x] style tag
  - [x] body tag
  - [x] article tag
  - [x] section tag
  - [x] nav tag
  - [x] aside tag
  - [x] h1 tag
  - [x] h2 tag
  - [x] h3 tag
  - [x] h4 tag
  - [x] h5 tag
  - [x] h6 tag
  - [x] hgroup tag
  - [x] header tag
  - [x] footer tag
  - [x] address tag
  - [x] p tag
  - [x] hr tag
  - [x] pre tag
  - [x] blockquote tag
  - [x] ol tag
  - [x] ul tag
  - [x] menu tag
  - [x] li tag
  - [x] dl tag
  - [x] dt tag
  - [x] dd tag
  - [x] figure tag
  - [x] figcaption tag
  - [x] main tag
  - [x] search tag
  - [x] div tag
  - [x] a tag
  - [x] em tag
  - [x] strong tag
  - [x] small tag
  - [x] s tag
  - [x] cite tag
  - [x] q tag
  - [x] dfn tag
  - [x] abbr tag
  - [x] ruby tag
  - [x] rt tag
  - [x] rp tag
  - [x] data tag
  - [x] time tag
  - [x] code tag
  - [x] var tag
  - [x] samp tag
  - [x] kbd tag
  - [x] sub tag
  - [x] sup tag
  - [x] i tag
  - [x] b tag
  - [x] u tag
  - [x] mark tag
  - [x] bdi tag
  - [x] bdo tag
  - [x] span tag
  - [x] br tag
  - [x] wbr tag
  - [x] ins tag
  - [x] del tag
  - [x] picture tag
  - [x] source tag
  - [x] img tag
  - [x] iframe tag
  - [x] embed tag
  - [x] object tag
  - [x] video tag
  - [x] track tag
  - [x] audio tag
  - [x] map tag
  - [x] area tag
  - [x] param tag
  - [x] table tag
  - [x] caption tag
  - [x] colgroup tag
  - [x] col tag
  - [x] tbody tag
  - [x] thead tag
  - [x] tfoot tag
  - [x] tr tag
  - [x] td tag
  - [x] th tag
  - [x] form tag
  - [x] label tag
  - [x] input tag
  - [x] button tag
  - [x] select tag
  - [x] datalist tag
  - [x] optgroup tag
  - [x] option tag
  - [x] textarea tag
  - [x] output tag
  - [x] progress tag
  - [x] meter tag
  - [x] fieldset tag
  - [x] legend tag
  - [x] details tag
  - [x] summary tag
  - [x] script tag
  - [x] noscript tag
  - [x] template tag
  - [x] slot tag
  - [x] canvas tag
- [ ] standard compliance validation
  - [x] attribute name
  - [x] attribute value
  - [x] element name
  - [x] html element validation
  - [x] head element validation
  - [ ] meta element validation
  - [x] title element validation
  - [x] base element validation
  - [ ] link element validation
  - [ ] style element validation
  - [ ] body element validation
  - [ ] article element validation
  - [ ] section element validation
  - [ ] nav element validation
  - [ ] aside element validation
  - [ ] h1 element validation
  - [ ] h2 element validation
  - [ ] h3 element validation
  - [ ] h4 element validation
  - [ ] h5 element validation
  - [ ] h6 element validation
  - [ ] hgroup element validation
  - [ ] header element validation
  - [ ] footer element validation
  - [ ] address element validation
  - [ ] p element validation
  - [ ] hr element validation
  - [ ] pre element validation
  - [ ] blockquote element validation
  - [ ] ol element validation
  - [ ] ul element validation
  - [ ] menu element validation
  - [ ] li element validation
  - [ ] dl element validation
  - [ ] dt element validation
  - [ ] dd element validation
  - [ ] figure element validation
  - [ ] figcaption element validation
  - [ ] main element validation
  - [ ] search element validation
  - [ ] div element validation
  - [ ] a element validation
  - [ ] em element validation
  - [ ] strong element validation
  - [ ] small element validation
  - [ ] s element validation
  - [ ] cite element validation
  - [ ] q element validation
  - [ ] dfn element validation
  - [ ] abbr element validation
  - [ ] ruby element validation
  - [ ] rt element validation
  - [ ] rp element validation
  - [ ] data element validation
  - [ ] time element validation
  - [ ] code element validation
  - [ ] var element validation
  - [ ] samp element validation
  - [ ] kbd element validation
  - [ ] sub element validation
  - [ ] sup element validation
  - [ ] i element validation
  - [ ] b element validation
  - [ ] u element validation
  - [ ] mark element validation
  - [ ] bdi element validation
  - [ ] bdo element validation
  - [ ] span element validation
  - [ ] br element validation
  - [ ] wbr element validation
  - [ ] ins element validation
  - [ ] del element validation
  - [ ] picture element validation
  - [ ] source element validation
  - [ ] img element validation
  - [ ] iframe element validation
  - [ ] embed element validation
  - [ ] object element validation
  - [ ] video element validation
  - [ ] track element validation
  - [ ] audio element validation
  - [ ] map element validation
  - [ ] area element validation
  - [ ] param element validation
  - [ ] table element validation
  - [ ] caption element validation
  - [ ] colgroup element validation
  - [ ] col element validation
  - [ ] tbody element validation
  - [ ] thead element validation
  - [ ] tfoot element validation
  - [ ] tr element validation
  - [ ] td element validation
  - [ ] th element validation
  - [ ] form element validation
  - [ ] label element validation
  - [ ] input element validation
  - [ ] button element validation
  - [ ] select element validation
  - [ ] datalist element validation
  - [ ] optgroup element validation
  - [ ] option element validation
  - [ ] textarea element validation
  - [ ] output element validation
  - [ ] progress element validation
  - [ ] meter element validation
  - [ ] fieldset element validation
  - [ ] legend element validation
  - [ ] details element validation
  - [ ] summary element validation
  - [ ] script element validation
  - [ ] noscript element validation
  - [ ] template element validation
  - [ ] slot element validation
  - [ ] canvas element validation
- [ ] foreign elm support
  - [ ] native css
  - [ ] native svg
  - [ ] native mathml 
- [ ] formatting
  - [ ] pretty print
</details>

## License

This project is licensed under the [BSD 3-Clause License](LICENSE).
