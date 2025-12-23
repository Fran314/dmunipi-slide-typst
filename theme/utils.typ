#let i18n-table-of-contents = context {
  let mapping = (
    en: "Table of Contents",
    it: "Indice",
  )
  mapping.at(text.lang, default: mapping.en)
}

#let i18n-display-date = date => context {
  if type(date) == str {
    date
  } else {
    let mapping = (
      en: (
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ),
      it: (
        "gennaio",
        "febbraio",
        "marzo",
        "aprile",
        "maggio",
        "giugno",
        "luglio",
        "agosto",
        "settembre",
        "ottobre",
        "novembre",
        "dicembre",
      ),
    )
    let months = mapping.at(text.lang, default: mapping.en)
    [#date.day() #months.at(date.month() - 1) #date.year()]
  }
}

/// Handles the positioning of the given content in the slide:
/// - if the given content is small enough to fit in one slide, center it
///   slightly bove the middle, by adding unequal vspace above and below
/// - otherwise, leave it as is, since it will be splitted in multiple
///   slides and it will mess up how the first split and the last split
///   will be positioned
#let offset-center(body) = context {
  let pw = page.width
  let ph = page.height
  let m = page.margin

  let (ml, mr, mt, mb) = if type(m) == dictionary {
    (
      m.at("left", default: 0pt),
      m.at("right", default: 0pt),
      m.at("top", default: 0pt),
      m.at("bottom", default: 0pt),
    )
  } else { (m, m, m, m) }

  // This seems a bit convoluted but it is necessary because the measures
  // are in mixed uints and must be converted to absolute units
  let available-height = measure(block(height: ph - mt - mb)).height
  let available-width = measure(block(width: pw - ml - mr)).width
  let size = measure(body, width: available-width)

  if size.height < available-height {
    v(1fr)
    body
    v(1.5fr)
  } else {
    body
  }
}
