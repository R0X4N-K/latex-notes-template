ENGINE = lualatex
MAIN   = main.tex
OUTDIR = build
ASSETS = res

SOURCES = $(MAIN) sources/preamble.tex sources/blocks.tex $(wildcard chapters/*.tex)
ASSET_FILES = $(shell [ -d $(ASSETS) ] && find $(ASSETS) -type f || echo)

all: $(OUTDIR)/main.pdf

$(OUTDIR)/main.pdf: $(SOURCES) $(ASSET_FILES)
	mkdir -p $(OUTDIR)
	# Copia le risorse (logo, immagini, ecc.) nell'output dir
	[ -d $(ASSETS) ] && rsync -a $(ASSETS)/ $(OUTDIR)/$(ASSETS)/ || true
	# 3 passaggi per TOC e segnalibri sempre allineati
	$(ENGINE) -interaction=nonstopmode -file-line-error -halt-on-error -output-directory=$(OUTDIR) $(MAIN)
	$(ENGINE) -interaction=nonstopmode -file-line-error -halt-on-error -output-directory=$(OUTDIR) $(MAIN)
	$(ENGINE) -interaction=nonstopmode -file-line-error -halt-on-error -output-directory=$(OUTDIR) $(MAIN)

	@test -f $(OUTDIR)/main.pdf || { echo "ATTENZIONE: build/main.pdf non trovato"; exit 1; }

clean:
	rm -rf $(OUTDIR)
