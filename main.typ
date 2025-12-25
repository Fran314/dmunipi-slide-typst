#import "./theme/lib.typ": *

#show: dmunipi-theme.with(
  /// Aspect ratio of the slides, possible values are "16-9" and "4-3"
  // aspect-ratio: "16-9",

  /// Whether or not to display the "Table of Contents" slide at each new
  /// section. Keep in mind that you can have this set to true and still skip
  /// some section slides by adding the label <touying:skip> next to the section
  /// heading
  // section-slides: true,

  config-info(
    /// Title of your presentation. It will be displayed on the title slide and,
    /// if you choose to have `fancy-footer: true`, in the footer
    title: [Your title],

    author: [Your name],

    /// A short version of your title which will override the true title in the
    /// footer if present
    short-title: [yr ttl], // optional

    subtitle: [Your subtitle], // optional
    course: [Name of your course], // optional
    IDnumber: [012345], // optional

    /// The date to be displayed on the title slide. Can either be a datetime
    /// object or a literal string
    date: datetime.today(),
    // date: datetime(day: 25, month: 12, year: 2025),
    // date: [December 25, 2025],
  ),

  config-store(
    /// Whether to display content in the footer or have it (mostly) empty
    // fancy-footer: false,

    /// Changes the stile of statements such as theorems, definitions...
    // headless-statements: false,

    /// Automatically starts the appendix after the ending slide
    // appendix-after-ending: true,
  ),

  config-common(
    /// Setting handout to true disables the `#pause`-s and generates a pdf
    /// suitable for printing
    // handout: false,
  ),

  /// Defines the colorscheme of the slides.
  /// - `neutral-lightest` is the color of the background
  /// - `neutral-darkest` is the color of the text
  /// - `primary` is the most-used color
  /// - `secondary` is the color used for accents such as links
  ///
  /// Try changing it, for example with `rgb("#006565")` as primary and
  /// `rgb("#00d595")` as secondary
  config-colors(
    //   neutral-lightest: rgb("#ffffff"),
    //   neutral-darkest: rgb("#000000"),
    //   primary: rgb("#003476"),
    //   secondary: rgb("#00b9f2"),
  ),
)

#title-slide()

= Introduction

== Some introduction slide

#lorem(10)

= Main results

== Another slide

#lorem(20)

#ending-slide()

#show: freeze-slide-counter

= Appendix

== Some hidden content

#lorem(30)
