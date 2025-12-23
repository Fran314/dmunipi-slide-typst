#import "./theme/lib.typ": *

#show: dmunipi-theme.with(config-info(
  title: [The Typst `dmunipi` theme],
  author: [Francesco Baldino],

  short-title: [`dmunipi` theme],
  subtitle: [A guide on usage and customization of the theme],
  course: [Master Degree in Mathematics],
  IDnumber: [025613],

  date: datetime.today(),
))

#title-slide()

= Introduction

#slide(title: [Introduction], subtitle: none)[
  This template is a Typst porting of #link("https://github.com/Cirdans-Home/dmunipi-slide")[Fabio Durastante's `dmslide` theme for Beamer]. It's made with the #link("https://touying-typ.github.io/")[Touying package] for creating slides and slide themes.

  #v(1em)

  Some features of the original theme might be missing, but all the fundamentals are already implemented, and should be easier to use thanks to Typst.

  #v(1em)

  In the following you will find a brief introduction on how to use Typst and this theme to prepare slides.
]

= Basic usage

== Getting started with Typst

If you're new to Typst, the easiest way to start a new project is with the #link("https://typst.app/")[Typst web app], similarly to Overleaf for LaTeX. The web app is free, but it requires creating an account.

Once you're set up in the web app, you can simply create a new empty project and procede from there.

#linebreak()

If you're more experienced or prefer to work locally, you can use the #link("https://github.com/typst/typst")[CLI typst compiler], which is open source. You can find instructions on how to install the CLI in the GitHub repo.

Once you've installed the CLI, creating a new project is as simple as creating a new folder and a `main.typ` file.

== Getting started with this theme

#grid(
  align: top,
  columns: (1fr, 14em),
  gutter: 1em,
  [
    To use this theme, you have to import the files of this repository in your empty project.

    #v(.5em)

    You can download the `ZIP` of this repository directly from GitHub through the green `<> Code` button in the top right.

    #v(.5em)

    From here you can either unzip it into your project folder if you're working locally, or unzip it and upload the resulting folder into the empty project on the web app.
  ],
  image("guide-assets/code-button.png"),
)

#v(.5em)

Now you can start editing the `main.typ` file! Note that only the `main.typ` file and `theme` folder are necessary, you can safely delete anything else.

#v(.75em)
#text(
  size: .8em,
)[Tip: is the font rendering weird? Go to the #link(<font-issues>)[troubleshooting section]]

== The `main.typ` file

#grid(
  align: top,
  columns: (1fr, 18em),
  gutter: 1em,
  [
    Ignoring the comments, the `main.typ` file starts with the code on the right.

    This is how the theme is imported and activated.

    It's not important to understand right now what each keyword does, you just need to know that this is where the theme is activated and global informations like your title are declared.

    If you want to override some of the styling of the theme, it must be done either here or below.

    You can read the omitted comments to understand better what each option does and which options are available.
  ],
  {
    ```typ
    #import "./theme/lib.typ": *

    #show: dmunipi-theme.with(
      config-info(
        title: [Your title],
        author: [Your name],
        short-title: [yr ttl],
        subtitle: [Your subtitle],
        course: [Name of your course],
        IDnumber: [012345],

        date: datetime.today(),
      ),
    )
    ```
  },
)



== Anatomy of a Typst document

In its most basic form, a Typst document is composed of headings (sections, subsections, ...) and paragraphs of text, like the following:

#text(size: 1em)[
  ```typ
  = Basic Usage

  == Getting started with Typst

  If you're new to Typst, the easiest way to start...
  ```
]

Within this theme, a section creates a new `Table of Contents` slide, and a subsection creates a new slide having the subsection title as its header, and the section title as the subheader.

== Basic formatting

Simple text formatting such as bullets, numbering and text styling can be done as follows:

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  These are bullet points:
  - something
  - something else

  The following are enumerated:
  + the first item
  + the second item

  This word is *bold* while this word is _italic_. This word is `monospace`
  ```,
  emoji.arrow.r.filled,
  [
    These are bullet points:
    - something
    - something else

    And these are enumerated:
    + the first item
    + the second item

    This word is *bold* while this word is _italic_. This word is `monospace`
  ],
)

== Math text

Writing math in Typst is much easier than LaTeX, look at the following examples:

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  $ A = pi r^2 $

  $ "area" = pi dot "radius"^2 $

  $ cal(A) :=
      { x in RR | x "is natural" } $

  #let x = 5
  $ #x < 17 $

  $ x_(n+1) = (x_n + a/x_n) / 2 $
  ```,
  emoji.arrow.r.filled,
  [
    $ A = pi r^2 $
    $ "area" = pi dot "radius"^2 $
    $
      cal(A) :=
      { x in RR | x "is natural" }
    $
    #let x = 5
    $ #x < 17 $
    $ x_(n+1) = (x_n + a/x_n) / 2 $
  ],
)

you can find more informations #link("https://typst.app/docs/reference/math/")[here].

== Coding

You can even display code with the correct syntax highlight by specifying the language:

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  // Necessary to manually call raw text instead of using the ```...``` syntax
  // in order to escape the inner ```
  raw(
    "Here is some rust code
```rust
fn main() {
}
```
And here is some Typst!
```typ
= Basic Usage

== Getting started with Typst

If you're new to Typst...
```",
    lang: "typ",
    block: true,
  ),
  emoji.arrow.r.filled,
  [
    Here is some rust code
    ```rust
    fn main() {
    }
    ```

    And here is some Typst!
    ```typ
    = Basic Usage

    == Getting started with Typst

    If you're new to Typst...
    ```
  ],
)

== Functions

Typst also has functions, which are denoted by a `#`. Some common functions that you might find useful are:

- ```typ #align()``` to change the alignment of the given content.
- ```typ #v()``` & ```typ #h()``` to add vertical and horizontal spacing
- ```typ #columns()``` to break the given content into columns
- ```typ #text()``` to change the style of the text
- ```typ #image()``` to add images (`.png`, `.jpg`, `.gif`, `.svg`, `.pdf`, `.webp`), and ```typ #figure()``` to wrap content and add a caption
- ```typ #table()``` and ```typ #grid()``` to organize content in grids and tables

#v(1em)

There are also the extremely powerful commands ```typ #set``` and ```typ #show``` which will take a while to understand and are usually used to change the global styling.

== `#basic-block` and `#title-block`

In this theme there are also two useful functions for wrapping content in blocks, which are ```typ #basic-block()``` for a standard block and ```typ #title-block()``` for a block with a title header:

#v(1fr)

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  #basic-block[This is a simple block]

  #title-block(title: "A title")[
    This block has an header with a title
  ]
  ```,
  emoji.arrow.r.filled,
  [
    #basic-block[This is a simple block]

    #title-block(title: [A title])[
      This block has an header with a title
    ]
  ],
)
== Theorems and other statements

This theme comes with useful functions for statements such as theorems:

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  #theorem(title: "Euclid's Theorem")[
    There are infinitely many primes.
  ]

  #theorem(number: "5")[
    There are infinitely many primes.
  ] <thm:euclid>

  A reference to @thm:euclid
  ```,
  emoji.arrow.r.filled,
  [
    #theorem(title: "Euclid's Theorem")[
      There are infinitely many primes.
    ]
    #theorem(number: "5")[
      There are infinitely many primes.
    ] <thm:euclid>
    A reference to @thm:euclid
  ],
)

There are also: `#definition`, `#lemma`, `#corollary`, `#proposition`, `#axiom`, `#postulate`, `#assumption`, `#property` and `#conjecture`!

== `#pause` and `#meanwhile`

Of course, you might want to gradually display the content of the slide!

You can use `#pause` to create a slide with only the content preceding the `#pause`.

If there's some content that you want displayed despite the `#pause`, you can put it after a `#meanwhile`:

#v(1em)

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  Show this content #pause and then this #pause and finally this!

  #meanwhile
  But always show this!
  ```,
  emoji.arrow.r.filled,
  [
    Show this content #pause and then this #pause and finally this!

    #meanwhile
    But always show this!
  ],
)

== `#uncover`

If you need to be more precise with your showing and hiding, you can use `#uncover`!

It is useful to show content only on a given interval of "subslides" while always reserving space for it.

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  3… #pause 2… #pause 1… #pause Tadaa!

  #meanwhile
  Display this #uncover("2-2")[$f(x) = x^2$] only on drum-roll `2`, and this #uncover("3-")[$f(x) = x^3$] after the third, but always reserve space for them
  ```,
  emoji.arrow.r.filled,
  [
    3… #pause 2… #pause 1… #pause Tadaa!

    #meanwhile
    Display this #uncover("2-2")[$f(x) = x^2$] only on drum-roll `2`, and this #uncover("3-")[$f(x) = x^3$] after the third, but always reserve space for them
  ],
)

#meanwhile
#text(
  size: .8em,
)[Note: there are also `#only` and `#alternatives`, but they don't behave nicely with handout mode and I suggest not to use them. If you want you can find more in the #link("https://touying-typ.github.io/docs/dynamic/complex")[documentation].]

== `#slide`, `#title-slide` and more

Some slides such as the title slide have their own function which needs to be called to be created. This is true for:
- ```typ #title-slide()```, which creates the initial slide of the presentation
- ```typ #ending-slide()```, which creates the _"Thank you for listening!"_ slide
- ```typ #focus-slide()[your content here]```, similar to an ending slide in appearence but for other type of contents

Additionally, while slides are automatically created for each subsection, you can manually declare a slide with ```typ #slide()[slide content here]```. This is most useful if you want to override some stile only on a single slide, as you will see in the Customization section.


= Customization

== Language

By default, some parts of these slides appear in English, such as _"Table of Contents"_, _"Theorem"_ or the month in the date.

You can change this behaviour by changing the text language with a simple ```typ #set text()``` at the top of the `main.typ`. This will change the language setting for all the presentation.

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  #theorem(title: "Euclid's Theorem")[
    There are infinitely many primes.
  ]
  ```,
  emoji.arrow.r.filled,
  [
    #theorem(title: "Euclid's Theorem")[
      There are infinitely many primes.
    ]
  ],

  ```typ
  #set text(lang: "it")
  #theorem(title: "Euclid's Theorem")[
    There are infinitely many primes.
  ]
  ```,
  emoji.arrow.r.filled,
  [
    #set text(lang: "it")
    #theorem(title: "Euclid's Theorem")[
      There are infinitely many primes.
    ]
  ],
)

== Per-slide customizations

Some of the following customization happen by changing some values inside of some `config-xyz()` in the initialization of the theme.

These settings can also be changed on single slides! To do so, you must manually create a slide with ```typ #slide()``` and then pass the config with the values you want, such as the following:

```typ
#slide(config: config-colors(primary: rgb("#006565")))[
  A slide with *updated primary color!*
]
```

If you need to use multiple `config-xyz()`, you can merge them using `utils.merge-dicts()`,

```typ
#slide(config: utils.merge-dicts(config-colors(/* … */), config-store(/* … */)))[
  A slide with many updated settings!
]
```

== Headless statements

By default, statements such as theorems are rendered in a `#title-block` with the theorem title at the top. This might occupy too much space in some cases, and can be disabled by setting `config-store(headless-statements: true)`


#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  #show: dmunipi-theme.with(
    // […]
    config-store(
      headless-statements: true,
    ),
  )

  #theorem(title: "Euclid's Theorem")[
    There are infinitely many primes.
  ]
  ```,
  emoji.arrow.r.filled,
  [
    #basic-block[#strong[Theorem (Euclid's Theorem):]#sym.space#emph[There are infinitely many primes.]]
  ],
)

== Fancy footer

#slide(config: config-store(fancy-footer: true))[
  By default, the footer of the slides only shows the slide counter. You can change the style of the footer by setting `config-store(fancy-footer: true)` to make it look like the footer in the current slide!

  ```typ
  #show: dmunipi-theme.with(
    // […]
    config-store(
      fancy-footer: true,
    ),
  )
  ```
]

== Colorscheme

#slide(config: config-colors(primary: rgb("#006565")))[
  You can even change the colorscheme of the slides! The colorscheme uses:
  - the `neutral-lightest` color for the background
  - the `neutral-darkest` color for most of the text
  - the `primary` color for most of the colored objects
  - the `secondary` color for links

  ```typ
   #show: dmunipi-theme.with(
    config-colors(
      primary: rgb("#006565"),
      secondary: rgb("#00d595"),
    ),
  )
  ```
]


== Advanced customization

These were the type of customization that come "pre-configured" in this theme, and are accessible through existing variables.

Typst actually allows you to customize the styling of the document much more in depth, thanks to the commands ```typ #set``` and ```typ #show```

#v(1em)

Explaining the usage of these commands is above the purpose of this guide. If you're interested, you will find everything you need to start in the #link("https://typst.app/docs/tutorial/advanced-styling/")[documentation].

#ending-slide()

#show: freeze-slide-counter


= Troubleshooting

== Font issues <font-issues>

By default, this theme uses the `Roboto` font family.

#v(1em)

#text(size: 1.1em, font: "Libertinus Serif")[
  If the font in your pdf looks like this instead of how it appears in the rest of this guide, then it's likely that you don't have the `Roboto` font installed on your system
]

#v(1em)

You can either choose to #link("https://fonts.google.com/specimen/Roboto")[download it] and install it, or edit the `theme/lib.typ` file to change the default font to something installed on your system of your liking

