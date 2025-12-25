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

#let set-config(config, body) = touying-set-config(config, body)

/// ------------------------------------------------
/// Blocks
/// ------------------------------------------------

#let _basic-block = (self: none, body) => {
  block(
    fill: self.colors.primary.lighten(90%),
    width: 100%,
    radius: 6pt,
    inset: 0.75em,
    body,
  )
}
#let basic-block = body => touying-fn-wrapper(_basic-block.with(body))

#let _title-block = (self: none, title: none, body) => {
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
#let title-block = (title: none, body) => touying-fn-wrapper(_title-block.with(
  title: title,
  body,
))

/// ------------------------------------------------
/// Slide show rules
/// ------------------------------------------------

#let invert-colorscheme = self => {
  utils.merge-dicts(self, config-colors(
    neutral-lightest: self.colors.primary,
    neutral-darkest: self.colors.neutral-lightest,
    primary: self.colors.neutral-lightest,
  ))
}

#let show-colors = (self: none, body) => {
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

#let statement-counter = richer-counter(identifier: "statement")
#let _make-statement = identifier => {
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
/// - title (string): The title of the slide. Default is `auto`.
///
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - repeat (auto): The number of subslides. Default is `auto`, which means touying will automatically calculate the number of subslides.
///
///   The `repeat` argument is necessary when you use `#slide(repeat: 3, self => [ .. ])` style code to create a slide. The callback-style `uncover` and `only` cannot be detected by touying automatically.
///
/// - setting (dictionary): The setting of the slide. You can use it to add some set/show rules for the slide.
///
/// - composer (function): The composer of the slide. You can use it to set the layout of the slide.
///
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the slide into three parts. The first and the last parts will take 1/4 of the slide, and the second part will take 1/2 of the slide.
///
///   If you pass a non-function value like `(1fr, 2fr, 1fr)`, it will be assumed to be the first argument of the `components.side-by-side` function.
///
///   The `components.side-by-side` function is a simple wrapper of the `grid` function. It means you can use the `grid.cell(colspan: 2, ..)` to make the cell take 2 columns.
///
///   For example, `#slide(composer: 2)[A][B][#grid.cell(colspan: 2)[Footer]]` will make the `Footer` cell take 2 columns.
///
///   If you want to customize the composer, you can pass a function to the `composer` argument. The function should receive the contents of the slide and return the content of the slide, like `#slide(composer: grid.with(columns: 2))[A][B]`.
///
/// - bodies (content): The contents of the slide. You can call the `slide` function with syntax like `#slide[A][B][C]` to create a slide.
#let slide(
  title: auto,
  subtitle: auto,
  header: auto,
  footer: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
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

  let new-setting = body => {
    show: std.align.with(horizon)
    show: show-colors.with(self: new-self)

    show: setting

    offset-center(body)
  }

  touying-slide(
    self: new-self,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})


/// Title slide for the presentation. You should update the information in the `config-info` function. You can also pass the information directly to the `title-slide` function.
///
/// Example:
///
/// ```typst
/// #show: stargazer-theme.with(
///   config-info(
///     title: [Title],
///     logo: emoji.city,
///   ),
/// )
///
/// #title-slide(subtitle: [Subtitle])
/// ```
///
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
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

/// Outline slide for the presentation.
///
/// - config (dictionary): is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - title (string): is the title of the outline. Default is `utils.i18n-outline-title`.
///
/// - level (int, none): is the level of the outline. Default is `none`.
///
/// - numbered (boolean): is whether the outline is numbered. Default is `true`.
#let outline-slide(
  config: (:),
  title: i18n-table-of-contents,
  subtitle: auto,
  numbered: false,
  ..args,
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

  let bullet = none
  let bullet = text(size: 1.5em, sym.triangle.filled.small.r)
  // let bullet = text(size: .75em, sym.hexa.filled)
  // let bullet = text(size: 2.5em, sym.bullet, baseline: .025em)
  // let bullet = text(size: 1em, emoji.bee, baseline: -.1em)
  // let bullet = text(size: 1em, emoji.frog, baseline: -.15em)

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
          if bullet != none {
            content.push(box(height: 0em, bullet))
          }
          if numbered {
            content.push({
              numbering("1.", ..counter(heading).at(it.element.location()))
              h(-.25em)
            })
          }
          content.push(link(it.element.location(), utils.short-heading(
            self: self,
            it.element,
          )))

          stack(dir: ltr, spacing: .5em, ..content)
        },
        ..args.named(),
      )
    }
    v(2fr)
  }

  touying-slide(self: self, body)
})


/// New section slide for the presentation. You can update it by updating the `new-section-slide-fn` argument for `config-common` function.
///
/// Example: `config-common(new-section-slide-fn: new-section-slide.with(numbered: false))`
///
/// - config (dictionary): is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - title (content, function): is the title of the section. The default is `utils.i18n-outline-title`.
///
/// - level (int): is the level of the heading. The default is `1`.
///
/// - numbered (boolean): is whether the heading is numbered. The default is `true`.
///
/// - body (none): is the body of the section. It will be passed by touying automatically.
#let new-section-slide(
  config: (:),
  title: i18n-table-of-contents,
  subtitle: auto,
  numbered: false,
  ..args,
  body,
) = outline-slide(
  config: config,
  title: title,
  subtitle: subtitle,
  numbered: numbered,
  ..args,
  body,
)



/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
///
/// - config (dictionary): is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
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



/// End slide for the presentation.
///
/// - config (dictionary): is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - title (string): is the title of the slide. The default is `none`.
///
/// - body (array): is the content of the slide.
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


/// Touying stargazer theme.
///
/// Example:
///
/// ```typst
/// #show: stargazer-theme.with(aspect-ratio: "16-9", config-colors(primary: blue))`
/// ```
///
/// Consider using:
///
/// ```typst
/// #set text(font: "Fira Sans", weight: "light", size: 20pt)`
/// #show math.equation: set text(font: "Fira Math")
/// #set strong(delta: 100)
/// #set par(justify: true)
/// ```
/// The default colors:
///
///
/// ```typst
/// config-colors(
///   primary: rgb("#005bac"),
///   primary-dark: rgb("#004078"),
///   secondary: rgb("#ffffff"),
///   tertiary: rgb("#005bac"),
///   neutral-lightest: rgb("#ffffff"),
///   neutral-darkest: rgb("#000000"),
/// )
/// ```
///
/// - aspect-ratio (string): is the aspect ratio of the slides. The default is `16-9`.
///
/// - title (content, function): is the title in the header of the slide. The default is `self => utils.display-current-heading(depth: self.slide-level)`.
#let dmunipi-theme(
  aspect-ratio: "16-9",
  section-slides: true,
  handout: false,
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
