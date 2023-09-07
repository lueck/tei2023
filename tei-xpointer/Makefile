PAGES_DIR ?= public
STYLESHEETS_DIR ?= ../stylesheets
IMAGES_DIR ?= .
FONTS_DIR ?= ../fonts

STYLESHEETS := $(patsubst %,$(PAGES_DIR)/%,$(shell find $(STYLESHEETS_DIR) -name "*.css"))
IMAGES := $(patsubst %,$(PAGES_DIR)/%,$(shell find $(IMAGES_DIR) -regex ".*\.\(jpg\|png\|gif\)"))
IMAGES2 := $(patsubst %,$(PAGES_DIR)/%,$(shell find $(IMAGES2_DIR) -regex ".*\.\(jpg\|png\|gif\)"))
FONTS := $(patsubst %,$(PAGES_DIR)/%,$(shell find $(FONTS_DIR) -name "*.ttf"))

#  -V revealjs-url="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.6.0"
LOCAL_PANDOC_ADDS ?= --slide-level=2 \
        --variable=theme:black \
        --variable=transition:none \
        --css=../stylesheets/style.css \
        --template=../templates/revealjs.html \

.PHONY: all clean clean*

all:	 $(PAGES_DIR)/slides.html $(IMAGES) $(STYLESHEETS)

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
	pandoc --to=revealjs --self-contained --standalone $(LOCAL_PANDOC_ADDS) $< -o $@

$(PAGES_DIR)/%.css: %.css
	mkdir -p $$(dirname $@)
	cp $< $@

$(PAGES_DIR)/%.jpg: %.jpg
	mkdir -p $$(dirname $@)
	cp $< $@

$(PAGES_DIR)/%.png: %.png
	mkdir -p $$(dirname $@)
	cp $< $@

$(PAGES_DIR)/%.gif: %.gif
	mkdir -p $$(dirname $@)
	cp $< $@

$(PAGES_DIR)/%.ttf: %.ttf
	mkdir -p $$(dirname $@)
	cp $< $@




clean:
	rm $(PAGES_DIR)/*.html

clean*:
	rm -r $(PAGES_DIR)
