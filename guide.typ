#import "./theme/lib.typ": *

#show: dmunipi-theme.with(config-info(
  title: [The Typst `dmunipi` theme],
  author: [Francesco Baldino],

  short-title: [`dmunipi` theme],
  subtitle: [A guide on usage and customization of the theme],
  course: [Here you should put the name of your course or degree],
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

== Animations: `#pause` and `#meanwhile`

Of course, you might want to gradually display the content of the slide!

You can use ```typ #pause``` to create a slide with only the content preceding the ```typ #pause```.

If there's some content that you want displayed despite the ```typ #pause```, you can put it after a ```typ #meanwhile```:

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

== More animations: `#only` and `#uncover`

If you need more control on hiding your content, you can use ```typ #only``` and ```typ #uncover```!

```typ #only``` and ```typ #uncover``` only show the given content on a specified interval, with the difference being that ```typ #uncover``` reserves space for the hiddend content, while ```typ #only``` doesn't.

An interval `"n-m"` means that the content gets shown from frame `n` to frame `m`, where a missing `n` or `m` means, respectively, _"since the start"_ and _"until the end"_.

#grid(
  columns: (2fr, auto, 1fr),
  gutter: 1em,
  align: horizon + left,
  ```typ
  1… #pause 2… #pause 3… #pause Tadaa!

  #meanwhile
  - show #only("2-3")[#emoji.star] from 2 to 3
  - uncover #uncover("3-")[#emoji.sun] from 3 to end
  ```,
  emoji.arrow.r.filled,
  [
    1… #pause 2… #pause 3… #pause Tadaa!

    #meanwhile
    - show #only("2-3")[#emoji.star] from 2 to 3
    - uncover #uncover("3-")[#emoji.sun] from 3 to end
  ],
)

#meanwhile
#text(
  size: .8em,
)[Note: depending on how you use ```typ #only``` and ```typ #uncover```, you might get some issues with #link(<handout-mode>)[handout mode]. There are some (possibly opinionated) #link(<animation-guidelines>)[animation guidelines] if you're interested in using them.]

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

== More control over slides

#slide(subtitle: "What?! A custom subtitle? That can't be!")[
  Slides are automatically created for each "```typ == subsection```", but you can also choose to create them manually with the ```typ #slide()``` function!

  This allows you to have more control on what gets displayed on the slide, for example you can have a custom subtitle, instead of having the section title:

  ```typ
  == More control over slides

  #slide(subtitle: "What?! A custom subtitle? That can't be!")[
    Slides are automatically created for each...
  ]
  ```
]


== Per-slide customizations

Some of the following customization happen by changing some values inside of some `config-xyz()` in the initialization of the theme.

These settings can also be changed on single slides! To do so, you must pass the config with the values you want, such as the following:

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

== Handout mode <handout-mode>

Animations like ```typ #pause```, ```typ #meanwhile``` and ```typ #uncover``` are useful when presenting the slides, but are problematic if someone wants to print out the slides (for example to take notes on them).

To remove all the animations and only create the "final" slide for each slide, you can use the handout mode, which is activated by enabling `config-common(handout: true)`

```typ
#show: dmunipi-theme.with(
  // […]
  config-common(handout: true),
)
```

== Headless statements

#slide(config: config-store(headless-statements: true))[
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
    theorem(title: "Euclid's Theorem")[
      There are infinitely many primes.
    ],
  )
]


== Fancy footer

#slide(config: config-store(fancy-footer: true))[
  By default, the footer of the slides only shows the slide counter. You can change the style of the footer by setting `config-store(fancy-footer: true)` to make it look like the footer in the current slide!

  ```typ
  #show: dmunipi-theme.with(
    // […]
    config-store(fancy-footer: true),
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


#ending-slide()

= Advanced usage & customization

== But wait... there's more!

The part before the ending slide was the "basic" introduction of how to use Typst and this slide theme.

What you have read so far should be more than enough for your typical presentation, but there's plenty more that can be done or customized!

#v(1em)

The rest of this guide is dedicated to a more advanced usage of the theme. It might be useful to get comfortable with the commands ```typ #set``` and ```typ #show```, for which you can find everything you need to start in the #link("https://typst.app/docs/tutorial/advanced-styling/")[documentation].

== Appendix

Anything after the ```typ #ending-slide()``` is countend as part of the appendix. The appendix is meant to be used as something that might be needed after the end of the presentation, but not strictly part of it (for example, some helping slides in case of questions).

The sections of the appendix will not result in the "Table of Contents"-s of the main part, and the slides of the appendix won't be counted as part of the shown total.

To disable this, you can set `config-store(appendix-after-ending: false)`

```typ
#show: dmunipi-theme.with(
  // […]
  config-store(appendix-after-ending: false),
)
```

== "From-here-on" customizations

== Animation guidelines <animation-guidelines>

While ```typ #pause``` displays the hidden content on the last animation slide, animations like ```typ #only``` and ```typ #uncover``` (and another, see next slide) don't do so necessarily.

The issue is that in handout mode, only the last frame of each animation is shown, meaning that content that doesn't go _"until the end"_ will not show up in handout mode.

#v(1em)

I suggest to *only* use intervals of the type `"n-"` in order not to have issues with handout mode.

#v(1em)

Similarly, with a combination of ```typ #place``` and ```typ #pause``` you can effectively end up with some background content hidden by foreground content on the last frame.

#v(1em)

Please don't. It's possible, but don't.

== Even animations: `#alternatives`

Speaking of animations that don't behave nicely with handout mode, there is also ```typ #alternatives```, which is be listed for sake of completeness but I don't recommend using for the same reasons as the slide before.

```typ #alternatives``` which switches between two or more contents depending on the frame, meaning that ```typ #alternatives[A][B]``` will render as `A` on the first frame and `B` on the second frame

#v(1em)

You can find more informations about it in the #link("https://touying-typ.github.io/docs/dynamic/complex")[documentation].

= Troubleshooting

== Font issues <font-issues>

By default, this theme uses the `Roboto` font family.

#v(1em)

#text(size: 1.1em, font: "Libertinus Serif")[
  If the font in your pdf looks like this instead of how it appears in the rest of this guide, then it's likely that you don't have the `Roboto` font installed on your system
]

#v(1em)

You can either choose to #link("https://fonts.google.com/specimen/Roboto")[download it] and install it, or edit the `theme/lib.typ` file to change the default font to something installed on your system of your liking

