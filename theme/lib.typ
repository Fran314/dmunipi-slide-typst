#import "@preview/touying:0.6.1": *
#import "@preview/theorion:0.4.1": *

// Fixes alignment of itemize and enumerations when the item has unusual height
// (eg if it has math or symbols)
#import "@preview/itemize:0.2.0" as el

#import "./utils.typ": *

/// ------------------------------------------------
/// Simple overrides
/// ------------------------------------------------
///
/// This section contains simple overrides which aim to simplify the usage
/// of the theme, basically by obscuring the `touying` layer

/// Update configurations for specific sections of the presentation.
/// This function allows you to temporarily override theme configurations for a portion
/// of your slides, such as changing colors or other settings for specific sections.
///
/// Examples:
///
/// ```typ
/// // Apply to a specific block of content
/// #set-config(config-colors(primary: purple))[
///   == A slide with purple
///   == Another slide with purple
/// ]
///
/// // Apply from here onwards
/// #show: set-config.with(config-colors(primary: purple))
/// == All slides from here will use purple
/// ```
///
/// - config (dictionary): The configuration overrides to apply. Use `config-xxx` functions
///   to specify the configuration.
///
/// - body (content): The content to which the configuration applies.
#let set-config(config, body) = touying-set-config(config, body)

/// ------------------------------------------------
/// Blocks
/// ------------------------------------------------

#let _basic-block(self: none, body) = {
  block(
    fill: self.colors.primary.lighten(90%),
    width: 100%,
    radius: 6pt,
    inset: 0.75em,
    body,
  )
}

/// Creates a basic colored block with rounded corners.
///
/// Example:
///
/// ```typ
/// #basic-block[This is some content]
/// ```
///
/// - body (content): The content to display inside the block.
#let basic-block(body) = touying-fn-wrapper(_basic-block.with(body))


#let _title-block(self: none, title: none, body) = {
  grid(
    columns: 1,
    row-gutter: 0pt,
    align(center, block(
      fill: self.colors.primary,
      width: 100%,
      radius: (top: 6pt),
      inset: (top: 0.4em, bottom: 0.4em, left: 0.5em, right: 0.5em),
      text(fill: self.colors.neutral-lightest, weight: "bold", title),
    )),

    block(
      fill: self.colors.primary.lighten(90%),
      width: 100%,
      radius: (bottom: 6pt),
      inset: (top: 0.4em, bottom: 0.5em, left: 0.5em, right: 0.5em),
      body,
    ),
  )
}

/// Creates a block with a colored title header and content area.
///
/// Example:
///
/// ```typ
/// #title-block(title: [This is the title])[This is the content]
/// ```
///
/// - title (content): The title to display in the header.
///
/// - body (content): The content to display in the block.
#let title-block(title: none, body) = touying-fn-wrapper(_title-block.with(
  title: title,
  body,
))

/// ------------------------------------------------
/// Slide show rules
/// ------------------------------------------------

#let invert-colorscheme(self) = {
  utils.merge-dicts(self, config-colors(
    neutral-lightest: self.colors.primary,
    neutral-darkest: self.colors.neutral-lightest,
    primary: self.colors.neutral-lightest,
  ))
}

#let show-colors(self: none, body) = {
  set text(fill: self.colors.neutral-darkest)

  set list(marker: box(height: 0em, text(
    fill: self.colors.primary,
    size: 2em,
    baseline: -.125em,
    sym.bullet,
  )))

  show link: it => if type(it.dest) == str or type(it.dest) == label {
    set text(fill: self.colors.secondary)
    it
  } else {
    it
  }

  show raw.where(block: false): it => box(
    fill: self.colors.primary.transparentize(90%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 6pt,
    it,
  )
  show raw.where(block: true): it => _basic-block(self: self, it)
  body
}

/// ------------------------------------------------
/// Statements (theorems, definitions, ...)
/// ------------------------------------------------
///
/// This section provides theorem-like environments including theorem, definition,
/// lemma, corollary, proposition, axiom, postulate, assumption, property, and conjecture.
///
/// Each statement can be created with an optional title and can be referenced.
/// The appearance can be controlled with the `headless-statements` configuration.
///
/// Examples:
///
/// ```typ
/// #theorem[All primes greater than 2 are odd.]
/// #definition(title: [Prime Number])[A natural number greater than 1...]
/// ```
///
/// To reference a statement, give it a label:
///
/// ```typ
/// #theorem[Some important result] <thm:important>
/// See @thm:important for details.
/// ```

#let statement-counter = richer-counter(identifier: "statement")
#let _make-statement(identifier) = {
  let (_, _, frame, show-frame) = make-frame(
    identifier,
    theorion-i18n-map.at(identifier),
    counter: statement-counter,
    render: (
      prefix: none,
      title: "",
      full-title: auto,
      body,
    ) => touying-fn-wrapper((self: none) => (self.store.statement-render-fn)(
      self: self,
      prefix: prefix,
      title: title,
      full-title: full-title,
      body,
    )),
  )

  // Hide number by default
  frame = frame.with(number: none)

  show-frame = body => {
    show: show-frame

    // Small fix of a bug in typst-theorion, waiting for the fix
    show ref: it => {
      let el = it.element
      if el != none and el.func() == figure and el.kind == identifier {
        link(el.location(), {
          let supplement = if it.supplement == auto { el.supplement } else {
            it.supplement
          }
          if supplement != none {
            supplement
            " "
          }
          context theorion-display-number(el)
        })
      } else {
        it
      }
    }
    body
  }
  return (frame, show-frame)
}
#let (theorem, show-theorem) = _make-statement("theorem")
#let (definition, show-definition) = _make-statement("definition")
#let (lemma, show-lemma) = _make-statement("lemma")
#let (corollary, show-corollary) = _make-statement("corollary")
#let (proposition, show-proposition) = _make-statement("proposition")
#let (axiom, show-axiom) = _make-statement("axiom")
#let (postulate, show-postulate) = _make-statement("postulate")
#let (assumption, show-assumption) = _make-statement("assumption")
#let (property, show-property) = _make-statement("property")
#let (conjecture, show-conjecture) = _make-statement("conjecture")

#let show-theorion(body) = {
  show: show-theorem
  show: show-definition
  show: show-lemma
  show: show-corollary
  show: show-proposition
  show: show-axiom
  show: show-postulate
  show: show-assumption
  show: show-property
  show: show-conjecture
  body
}

/// Default slide function for the presentation.
///
/// Examples:
///
/// ```typ
/// #slide[
///   Content with automatic title from heading.
/// ]
///
/// #slide(title: [Custom Title])[
///   Content with custom title.
/// ]
///
/// #slide(title: [Custom Title], config: config-colors(primary: purple))[
///   Content with custom title.
/// ]
/// ```
///
/// - title (content, auto): The title of the slide, displayed in the header. Default is `auto`,
///   which displays the current level-2 heading.
///
/// - subtitle (content, auto): The subtitle of the slide, displayed below the title in the header.
///   Default is `auto`, which displays the current level-1 heading (section name).
///
/// - config (dictionary): Configuration overrides for this slide. Use `config-xxx` functions
///   to specify the configuration. For multiple configurations, use `utils.merge-dicts` to merge them.
///
/// - bodies (content): The contents of the slide. You can pass multiple content blocks.
#let slide(
  title: auto,
  subtitle: auto,
  config: (:),
  ..bodies,
) = touying-slide-wrapper(self => context {
  let freeze-slide-counter = self.at("freeze-slide-counter", default: false)
  if self.store.appendix-after-ending {
    let ending-exists = query(label("ending-slide")).len() > 0
    if ending-exists {
      let current-page = here().page()
      let ending-page = locate(label("ending-slide")).page()
      if current-page > ending-page {
        freeze-slide-counter = true
      }
    }
  }

  // Required to create new-self because self here is read-only since it's
  // inside context, which in turn is needed to have access to here()
  let new-self = utils.merge-dicts(
    self,
    config,
    config-page(fill: self.colors.neutral-lightest),
    config-common(freeze-slide-counter: freeze-slide-counter),
  )

  new-self.store.title = title
  new-self.store.subtitle = subtitle

  let setting = body => {
    show: std.align.with(horizon)
    show: show-colors.with(self: new-self)

    offset-center(body)
  }

  touying-slide(self: new-self, setting: setting, ..bodies)
})


/// Title slide for the presentation. Displays the presentation information including title,
/// subtitle, course, author, ID number, and date, along with the Università di Pisa logo.
///
/// You should set the information using the `config-info` function in the theme initialization.
///
/// Examples:
///
/// ```typ
/// #title-slide()
/// ```
///
/// Or with custom configuration:
///
/// ```typ
/// #title-slide(config: config-colors(primary: purple))
/// ```
///
/// - config (dictionary): Configuration overrides for this slide. Use `config-xxx` functions
///   to specify the configuration. For multiple configurations, use `utils.merge-dicts` to merge them.
#let title-slide(config: (:)) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config, config-page(
    fill: self.colors.neutral-lightest,
  ))

  self.store.title = none
  self.store.subtitle = none

  let body = {
    show: show-colors.with(self: self)

    place(
      top + left,
      block(
        width: 100%,
        height: 100%,
        {
          set align(horizon)
          set text(size: .9em)

          let content = (
            text(
              size: 1.2em,
              weight: "bold",
              fill: self.colors.primary,
              self.info.title,
            ),
          )

          if self.info.subtitle != none {
            content.push(text(fill: self.colors.primary, self.info.subtitle))
          }

          if self.info.course != none {
            content.push(text(fill: self.colors.primary, self.info.course))
          }

          if self.info.IDnumber != none {
            content.push([#text(weight: "bold", self.info.author) (#self.info.IDnumber)])
          } else {
            content.push(text(weight: "bold", self.info.author))
          }

          content.push(v(1.5em))
          content.push(text(size: .8em, i18n-display-date(self.info.date)))

          offset-center(stack(dir: ttb, spacing: .8em, ..content))
        },
      ),
    )
  }

  // This section is all done in `%` so that changing the font size doesn't
  // change the appearance
  let background = {
    set align(bottom + right)
    polygon(
      stroke: none,
      fill: self.colors.primary,
      // Negative coordinates because in my head it made more sense to spawn the polygon
      // from the bottom right corner, since it is anchored to the bottom right of the slide
      (0%, 0%),
      (0%, -100%),
      (-25%, -100%),
      (-45%, 0%),
    )
    place(bottom + right, dx: -5%, dy: -5%, image(
      "assets/matematica-unipi-dx.svg",
      width: 30%,
    ))
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: self.colors.neutral-lightest,
      background: background,
      footer: none,
    ),
  )
  touying-slide(self: self, body)
})

/// Outline slide for the presentation. Displays a table of contents with all sections.
///
/// The outline automatically excludes content after the ending slide if present.
/// The appearance can be customized using `toc-marker` and `toc-numbering` in `config-store`.
///
/// Examples:
///
/// ```typ
/// #outline-slide()
/// ```
///
/// Or with custom title:
///
/// ```typ
/// #outline-slide(title: [Contents])
/// ```
///
/// - config (dictionary): Configuration overrides for this slide. Use `config-xxx` functions
///   to specify the configuration. For multiple configurations, use `utils.merge-dicts` to merge them.
///
/// - title (content): The title of the outline. Default is "Table of Contents" (localized).
///
/// - subtitle (content, auto): The subtitle displayed in the header. Default is `auto`.
#let outline-slide(
  config: (:),
  title: i18n-table-of-contents,
  subtitle: auto,
) = touying-slide-wrapper(self => {
  self.store.title = title
  self.store.subtitle = subtitle

  self = invert-colorscheme(self)
  self = utils.merge-dicts(
    self,
    config,
    config-page(fill: self.colors.neutral-lightest, footer: none),
    config-common(freeze-slide-counter: true),
  )

  let body = {
    set align(horizon)
    v(1fr)
    {
      show: show-colors.with(self: self)
      components.progressive-outline(
        title: none,
        alpha: 20%,
        level: auto,
        depth: 1,
        transform: (cover: false, alpha: 20%, ..args, it) => context {
          let ending-exists = query(label("ending-slide")).len() > 0
          if ending-exists {
            let current-page = here().page()
            let ending-page = locate(label("ending-slide")).page()
            if current-page < ending-page {
              if it.element.location().page() > ending-page {
                return
              }
            }
          }

          let text-color = if cover {
            self.colors.primary.transparentize(100% - alpha)
          } else {
            self.colors.primary
          }
          set text(fill: text-color, size: 1.1em)

          v(1fr)

          let content = ()
          if self.store.toc-marker != none {
            content.push(box(height: 0em, self.store.toc-marker))
          }
          if self.store.toc-numbering != none {
            content.push({
              numbering(self.store.toc-numbering, ..counter(heading).at(
                it.element.location(),
              ))
              h(-.25em)
            })
          }
          content.push(link(it.element.location(), utils.short-heading(
            self: self,
            it.element,
          )))

          stack(dir: ltr, spacing: .5em, ..content)
        },
        // ..args.named(),
      )
    }
    v(2fr)
  }

  touying-slide(self: self, body)
})


/// New section slide displayed automatically at each new section (level-1 heading).
/// This slide shows the table of contents with the current section highlighted.
///
/// By default, this slide is shown for every section. You can disable it globally by setting
/// `section-slides: false` in the theme initialization, or skip it for specific sections by
/// adding the `<touying:skip>` label after the section heading.
///
/// Examples:
///
/// ```typ
/// = Introduction
/// // A table of contents slide is automatically created here
///
/// == First Slide
/// Content...
///
/// = Background <touying:skip>
/// // No table of contents slide here due to the label
///
/// == Another Slide
/// Content...
/// ```
///
/// You can also manually call this function:
///
/// ```typ
/// #new-section-slide(title: [Custom Title])
/// ```
///
/// - config (dictionary): Configuration overrides for this slide. Use `config-xxx` functions
///   to specify the configuration. For multiple configurations, use `utils.merge-dicts` to merge them.
///
/// - title (content): The title of the slide. Default is "Table of Contents" (localized).
///
/// - subtitle (content, auto): The subtitle displayed in the header. Default is `auto`.
///
/// - body (content): The section body, passed automatically by touying.
#let new-section-slide(
  config: (:),
  title: i18n-table-of-contents,
  subtitle: auto,
  body,
) = outline-slide(config: config, title: title, subtitle: subtitle)



/// Focus slide for emphasizing important content with large text, centered on the slide.
///
/// This slide has no header or footer, and does not increment the slide counter.
///
/// Examples:
///
/// ```typ
/// #focus-slide[Wake up!]
/// ```
///
/// Or with custom configuration:
///
/// ```typ
/// #focus-slide(config: config-colors(primary: purple))[
///   Important message!
/// ]
/// ```
///
/// - config (dictionary): Configuration overrides for this slide. Use `config-xxx` functions
///   to specify the configuration. For multiple configurations, use `utils.merge-dicts` to merge them.
///
/// - body (content): The content to display, typically a short phrase or key message.
#let focus-slide(
  config: (:),
  body,
) = touying-slide-wrapper(self => {
  self.store.title = none
  self.store.subtitle = none

  self = invert-colorscheme(self)
  self = utils.merge-dicts(
    self,
    config,
    config-page(fill: self.colors.neutral-lightest, footer: none),
    config-common(freeze-slide-counter: true),
  )

  touying-slide(self: self, {
    align(horizon + center, {
      show: show-colors.with(self: self)
      set text(size: 2em)
      v(1fr)
      body
      v(1.5fr)
    })
  })
})



/// Ending slide for the presentation. Displays a thank you message by default.
/// This slide marks the end of the main presentation; any slides after this are
/// considered appendix material.
///
/// If `appendix-after-ending: true` is set (default), slides after this will not increment
/// the slide counter, allowing you to add backup slides that don't affect the slide count.
///
/// Examples:
///
/// ```typ
/// #ending-slide()
/// ```
///
/// Or with custom content:
///
/// ```typ
/// #ending-slide[
///   Thank you!
///   #v(1em)
///   Questions?
/// ]
/// ```
///
/// - config (dictionary): Configuration overrides for this slide. Use `config-xxx` functions
///   to specify the configuration. For multiple configurations, use `utils.merge-dicts` to merge them.
///
/// - ..args (content): Optional custom content. If not provided, displays the presentation
///   title and a default "Thank you for listening! Any question?" message.
#let ending-slide(
  config: (:),
  ..args,
) = touying-slide-wrapper(self => {
  self.store.title = none
  self.store.subtitle = none

  self = invert-colorscheme(self)
  self = utils.merge-dicts(
    self,
    config,
    config-page(fill: self.colors.neutral-lightest, footer: none),
    config-common(freeze-slide-counter: true),
  )

  let body = if args.pos().len() > 0 { args.pos().sum(default: none) } else {
    text(size: 2em, self.info.title)
    v(0em)
    text(size: 1.2em, style: "italic")[Thank you for listening! \ Any question?]
  }

  touying-slide(self: self, config: (appendix: true), utils.label-it(
    align(horizon + center, {
      set text(self.colors.primary)
      v(1fr)
      body
      v(1.5fr)
    }),
    "ending-slide",
  ))
})


/// dmunipi (Dipartimento di Matematica, Università di Pisa) presentation theme.
///
/// A clean, professional theme designed for academic presentations at the University of Pisa's
/// Department of Mathematics. Features the university branding and colors.
///
/// Example:
///
/// ```typ
/// #show: dmunipi-theme.with(
///   aspect-ratio: "16-9",
///   section-slides: true,
///
///   config-common(
///     handout: false,
///   ),
///
///   config-info(
///     title: [Title of the presentation],
///     author: [Your Name],
///     short-title: [Short title],
///     subtitle: [Subtitle of the presentation],
///     course: [Name of the course],
///     IDnumber: [012345],
///     date: datetime.today(),
///   ),
///
///   config-store(
///     fancy-footer: false,
///     headless-statements: false,
///     appendix-after-ending: true,
///     toc-numbering: none,
///     toc-marker: text(size: 1.5em, sym.triangle.filled.small.r),
///   ),
///
///   config-colors(
///     neutral-lightest: rgb("#ffffff"),
///     neutral-darkest: rgb("#000000"),
///     primary: rgb("#003476"),
///     secondary: rgb("#00b9f2"),
///   ),
/// )
/// ```
/// 
/// **config-common options:**
///
/// - handout (boolean): When `true`, disables `#pause` commands and generates a PDF suitable
///   for printing. Default is `false`.
///
/// **config-info options (presentation metadata):**
///
/// - title (content): Main title of the presentation. Required.
///
/// - author (content): Author name(s). Required.
///
/// - short-title (content, auto): Abbreviated title for the footer (when `fancy-footer: true`).
///   If `auto`, uses the full title. Optional.
///
/// - subtitle (content): Subtitle for the presentation. Displayed on title slide. Optional.
///
/// - course (content): Course name or context. Displayed on title slide. Optional.
///
/// - IDnumber (content): Student or identification number. Displayed on title slide. Optional.
///
/// - date (datetime, content): Date to display on title slide. Can be a datetime object
///   or formatted content. Default is `datetime.today()`.
///
/// **config-store options (theme behavior):**
///
/// - fancy-footer (boolean): When `true`, displays a footer containing author, title,
///   and page numbers. When `false`, shows only page numbers. Default is `false`.
///
/// - headless-statements (boolean): Changes the style of theorem-like environments.
///   When `false` (default), statements appear in colored blocks. When `true`, they
///   appear as inline formatted text.
///
/// - appendix-after-ending (boolean): When `true` (default), slides after `#ending-slide()`
///   are treated as appendix material and don't increment the slide counter.
///
/// - toc-numbering (string, none): Numbering format for table of contents items.
///   Options: `none` (default, no numbers), `"1"`, `"1."`, etc.
///   See Typst's numbering documentation for all formats.
///
/// - toc-marker (content, none): Bullet marker for table of contents items.
///   Default is a right-pointing triangle. Set to `none` to disable.
///   Examples: `text(size: .75em, sym.hexa.filled)`, `text(size: 1em, emoji.frog)`
///
/// **config-colors options (color scheme):**
///
/// - neutral-lightest (color): Background color. Default: `rgb("#ffffff")`.
///
/// - neutral-darkest (color): Text color. Default: `rgb("#000000")`.
///
/// - primary (color): Primary accent color used throughout the theme.
///   Default: `rgb("#003476")`.
///
/// - secondary (color): Secondary accent color for links and highlights.
///   Default: `rgb("#00b9f2")`.
/// 
/// **Main parameters:**
///
/// - aspect-ratio (string): The aspect ratio of the slides. Options: `"16-9"` (default) or `"4-3"`.
/// 
/// - section-slides (boolean): Whether to display a table of contents slide at each new section.
///   You can skip specific sections by adding `<touying:skip>` after the heading. Default is `true`.
/// 
/// - ..args (arguments): Additional configuration options. Pass `config-common()`, `config-info()`,
///   `config-store()`, and `config-colors()` here to configure the theme.
#let dmunipi-theme(
  aspect-ratio: "16-9",
  section-slides: true,
  ..args,
  body,
) = {
  let header(self) = {
    utils.call-or-display(self, self.store.header)
  }
  let footer(self) = {
    utils.call-or-display(self, self.store.footer)
  }

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      header: header,
      footer: footer,
      header-ascent: .5em,
      footer-descent: .5em,
      margin: (top: 5.5em, bottom: 2.5em, x: 2.75em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: if section-slides {
        new-section-slide
      },
      frozen-counters: (statement-counter,),
      handout: false,
    ),
    config-methods(
      init: (self: none, body) => {
        show: show-theorion

        set heading(numbering: "1")
        set text(size: 18pt, font: "Roboto")

        show: el.default-enum-list


        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#000000"),
      primary: rgb("#003476"),
      secondary: rgb("#00b9f2"),
    ),
    config-info(course: none, IDnumber: none, date: datetime.today()),
    config-store(
      title: none,
      subtitle: none,
      fancy-footer: false,
      headless-statements: false,
      appendix-after-ending: true,
      toc-marker: text(size: 1.5em, sym.triangle.filled.small.r),
      toc-numbering: none,
      header: self => {
        show: show-colors.with(self: self)
        set std.align(bottom)
        show: components.cell.with(inset: (x: 2.75em))
        set text(fill: self.colors.primary, weight: "bold")

        let logo = read("./assets/logo.svg").replace(
          "#000000",
          self.colors.primary.to-hex(),
        )

        stack(dir: ltr, spacing: 1.5em, image(bytes(logo), height: 100%), {
          show: components.cell.with(inset: (y: .5em))
          stack(
            dir: ttb,
            spacing: 0.65em,
            text(weight: "bold", size: 1.4em, if self.store.title != auto {
              self.store.title
            } else {
              utils.display-current-heading(level: 2, numbered: false)
            }),
            text(weight: "regular", size: 0.8em, if self.store.subtitle
              != auto {
              self.store.subtitle
            } else { utils.display-current-heading(level: 1) }),
          )
        })
      },

      footer: self => {
        set std.align(horizon)

        if self.store.fancy-footer {
          block(height: 100%, width: 100%, fill: self.colors.primary, {
            self = invert-colorscheme(self)
            show: show-colors.with(self: self)
            show: components.cell.with(inset: (x: 2.75em))
            set text(size: .75em)

            if not self.freeze-slide-counter {
              context utils.slide-counter.display()
              h(.15em)
              [/]
              h(.15em)
              context utils.last-slide-number
            }

            h(1fr)

            self.info.author
            h(.5em)
            [|]
            h(.5em)
            if self.info.short-title != auto {
              self.info.short-title
            } else {
              self.info.title
            }
          })
        } else {
          show: show-colors.with(self: self)
          show: components.cell.with(inset: (x: 2.75em))
          set text(size: .75em)
          if not self.freeze-slide-counter {
            context utils.slide-counter.display()
            h(.15em)
            [/]
            h(.15em)
            context utils.last-slide-number
          }
        }
      },

      statement-render-fn: (
        self: none,
        prefix: none,
        title: "",
        full-title: auto,
        body,
      ) => {
        if self.store.headless-statements {
          _basic-block(self: self)[#strong[#full-title:]#sym.space#emph(body)]
        } else {
          _title-block(self: self, title: full-title, emph(body))
        }
      },
    ),
    ..args,
  )

  body
}
