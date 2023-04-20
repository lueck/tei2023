---
title: TEI XPointer Schemes – Implementation and Example Application
---

The XPointer framework is one of those W3C notions that is dead
today. Same with the TEI XPointer schemes. The cause of dead is
manifold. Most importantly, there has never been an full-grown
implementation of an XPointer processor. Furthermore, it is unclear,
what a processor is to do with the pointers, that actually only
*point* to a portion of a resource. As a consequence, XPointers have
never grown to their paradigmatic field of application, in which they
could have proven their value.  Specified in the SATS section of the
guidelines, TEI XPointer schemes occur at several other sections,
among them dead-by-design SASO.  This bad company appears to be
symptomatic.

However, there is a paradigmatic field of application for the TEI
XPointer schemes: the Web-Annotations-like `<annotation>` element and
its `@target` attribute. If this element is really meant to
"represent[] an annotation following the Web Annotation Data Model",
like the TEI reference states, then we need a referencing mechanism,
that is compatible with the Web Annotation's selector mechanism, and
that at a specification level.  The TEI XPointer schemes not only do
satisfy this requirement, but are the only specified component of the
TEI, that satisfies it.

This short paper first introduces a full implementation of the TEI
XPointer schemes: an ANTLR-based XPointer parser, a Saxon-based
processor, and its
APIs.^[[**https://github.com/scdh/tei-xpointer-schemes**](https://github.com/scdh/tei-xpointer-schemes)]
The processor has a Java API and an XPath API. This enables the
evaluation of XPointers in XSLT and XQuery through XPath function
extensions, e.g., `xptr:get-sequence(...)` for getting the sequence of
items pointed to, or `xptr:type(...)` to get the pointer's type. There
are also conversion functions for translating TEI XPointers to Web
Annotation Selector schemes and vice versa.

The paper then showcases the application of TEI XPointers in
`annotation/@target` in a project from the field of Old Testament
research. Here, portions of the Masoretes' book of Ijob are annotated
and related to translations in Septuagint and Targum, in order to
examine semantic deferrals in the textual traditions. This is a
specific application in the more general domain of inquiries on
intertextuality. A TEI-based approach proves its value, when there's a
mix of stable texts and texts still under editing––provided that the
data model will allow straight forward transformation to linked open
data. The TEI XPointers schemes serve as a surety.

# References

- Grosso, P. et al. (2003). XPointer Framework. W3C Recommendation 25
  March 2003. [https://www.w3.org/TR/xptr-framework/](https://www.w3.org/TR/xptr-framework/)

- TEI. (2023). P5: Guidelines for Electronic Text Encoding and
  Interchange. Version 4.6.0. Last updated on 4th April 2023, revision
  f18deffba. [https://tei-c.org/release/doc/tei-p5-doc/en/html/index.html](https://tei-c.org/release/doc/tei-p5-doc/en/html/index.html)

- Sanderson, R. et al. (2017). Web Annotation Vocabulary W3C
  Recommendation 23
  February 2017. [https://www.w3.org/TR/annotation-vocab/](https://www.w3.org/TR/annotation-vocab/)

- Cayless, H. (2013). Rebooting TEI Pointers. In: Journal of the Text
  Encoding Initiative. Issue 6, 2013. doi
  [10.4000/jtei.907](https://doi.org/10.4000/jtei.907)
