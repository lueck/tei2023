PAGES_DIR ?= public
STYLESHEETS_DIR ?= stylesheets
IMAGES_DIR ?= .
FONTS_DIR ?= fonts

SAXON_JAR := ~/.m2/repository/net/sf/saxon/Saxon-HE/10.6/Saxon-HE-10.6.jar
XSLT_CMD := java -cp $(SAXON_JAR) net.sf.saxon.Transform

HTML_SLIDES := $(patsubst %.md,$(PAGES_DIR)/%.html,$(filter-out README.md, $(wildcard *.md)))
STYLESHEETS := $(patsubst %,$(PAGES_DIR)/%,$(shell find $(STYLESHEETS_DIR) -name "*.css"))
IMAGES := $(patsubst %,$(PAGES_DIR)/%,$(shell find $(IMAGES_DIR) -regex ".*\.\(jpg\|png\)"))
FONTS := $(patsubst %,$(PAGES_DIR)/%,$(shell find $(FONTS_DIR) -name "*.ttf"))

#  -V revealjs-url="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.6.0"
LOCAL_PANDOC_ADDS ?= --slide-level=2 \
        --variable=theme:black \
        --variable=transition:none \
        --css=stylesheets/style.css \
        --template=templates/revealjs.html \

.PHONY: all clean clean*

all: $(PAGES_DIR)/standoff-tools/slides.html $(PAGES_DIR)/standoff-tools/slides2.html $(IMAGES)

poster: oxbytei/poster.pdf 

%.pdf:	%.tex
	cd $(shell dirname $@) && \
	lualatex $(shell basename $<) && \
	lualatex $(shell basename $<) && \
	lualatex $(shell basename $<)

%.odt:	%.md
	pandoc $< -t odt -o $@

$(PAGES_DIR)/%.html: %.md
	mkdir -p $$(dirname $@)
	pandoc --to=revealjs --standalone $(LOCAL_PANDOC_ADDS) $< -o $@

$(PAGES_DIR)/%.css: %.css
	mkdir -p $$(dirname $@)
	cp $< $@

$(PAGES_DIR)/%.jpg: %.jpg
	mkdir -p $$(dirname $@)
	cp $< $@

$(PAGES_DIR)/%.png: %.png
	mkdir -p $$(dirname $@)
	cp $< $@

$(PAGES_DIR)/%.ttf: %.ttf
	mkdir -p $$(dirname $@)
	cp $< $@


%.txt: %.xml
	$(XSLT_CMD) -xsl:resources/xsl/text.xsl -s:$< -o:$@

%.words.txt: %.txt
	wc -w $< > $@



clean:
	rm $(PAGES_DIR)/*.html

clean*:
	rm -r $(PAGES_DIR)
