---
title: <ܬܸ݂> for Non-Western Scripts
author: Christian Lück
---

Encoding right-to-left script in TEI-XML is a hassle unless one uses an editor that hides away the tags. The problem arises when element names in Latin script interrupt the right-to-left rendering on the editor screen by the Unicode Bidirectional Algorithm. (Davis et al. 2022) However, hiding the tags is not the only solution. With &lt;altIdent&gt; TEI offers a means for declaring alternative names for elements and attributes: names in another language and even in another script. Thus, we can have valid right-to-left-only TEI documents in XML version 1.1, which are readable and editable while tags are visible.

However, using &lt;altIdent&gt; quickly feels like introducing entropy to the schema. Therefore, the paper suggests not to translate, but to transliterate identifiers. Compared to translation, transliteration is a mechanical process. The coding effort is low. An implementation is at hand in the Unicode ICU library,^[[https://icu.unicode.org/home](https://icu.unicode.org/home)] and there is even an XPath binding for this library,^[[https://github.com/SCDH/icu-xpath-bindings](https://github.com/SCDH/icu-xpath-bindings) implemented by one of the authors of this paper.] so that transliteration is available in XSLT and XQuery. Thus, generating a full ODD with element and attribute aliases in Arabic, Syriac, Hebrew, etc. script becomes simple and fast.^[First stylesheets for transliterating documents and ODDs are in the repository of this paper: [https://github.com/lueck/tei2023](https://github.com/lueck/tei2023).]  It can be pre-built so that the hurdle for encoding non-western script in TEI becomes much lower. The &lt;ܬܸ݂&gt; from the paper's title is a &lt;TEI&gt; tag transliterated to Syriac script: `<altIdent xml:lang="en_Syrc">ܬܸ݂</altIdent>`.

Transforming a TEI document with alternative names to its equivalent
with names in Latin script is always possible through the mapping of
identifiers and alternative identifiers deposited in the ODD. Direct
re-transliteration of alternative names is only possible under certain
preconditions.

The paper will first analyze the problem when bidirectional text is
displayed on a screen. It will show how well-formed tags look in a
right-to-left script. It will then introduce the transliteration of
XML names in documents and ODDs. It will discuss challenges regarding
attributes in the XML namespace, especially `@xml:id`.

# References

- Davis, Mark et al. (2022): Unicode Standard Annex #9: Unicode
  Bidirectional Algorithm Latest version:
  https://www.unicode.org/reports/tr9/ Version 15.0.0:
  https://www.unicode.org/reports/tr9/tr9-46.html
  
# The Authors

Christian Lück has a PhD in German literature studies. He also studied
few semesters in physics and computer science. He currently works as a
research software engineer at University of Münster, Germany.
