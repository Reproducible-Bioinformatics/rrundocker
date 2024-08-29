default: build

.PHONY: document test clean check build clean 

PKG_NAME := rrundocker
PKG_VERS := 0.0.3
PKG_TAR := $(PKG_NAME)_$(PKG_VERS).tar.gz

R := R

document:
	$(R) -e "devtools::document()"

test:
	true # Placeholder.

clean:
	rm -rf $(PKG_TAR) $(PKG_NAME).Rcheck

check: build
	R CMD check $(PKG_TAR)

build: clean document test
	$(R) CMD build .

clean:
	rm -rf $(PKG_NAME).Rcheck $(PKG_TAR)
