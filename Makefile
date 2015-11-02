PKG_NAME = $(shell oasis query name)
DIR = $(PKG_NAME)-$(shell oasis query version)
PKG_TARBALL = $(DIR).tar.gz

DISTFILES = _oasis setup.ml _tags lib lwt

ATDGEN = lib/raygun_j.ml lib/raygun_j.mli lib/raygun_t.ml lib/raygun_t.mli

default: all opam/opam

all byte native setup.log: setup.data
	ocaml setup.ml -build

configure: setup.data
setup.data: setup.ml
	ocaml setup.ml -configure --enable-lwt

setup.ml: _oasis $(ATDGEN)
	oasis setup -setup-update dynamic
	touch $@

$(ATDGEN): lib/raygun.atd
	atdgen -j $<
	atdgen -t $<

doc install uninstall reinstall: setup.log
	ocaml setup.ml -$@

opam/opam: _oasis
	oasis2opam --local -y

.PHONY: dist tar
dist tar: setup.ml
	mkdir -p $(DIR)
	for f in $(DISTFILES); do \
	  cp -r $$f $(DIR); \
	done
# Make a setup.ml independent of oasis:
	cd $(DIR) && oasis setup
	tar -zcvf $(PKG_TARBALL) $(DIR)
	$(RM) -r $(DIR)



clean:
	ocaml setup.ml -clean
	$(RM) $(ATDGEN) $(PKG_TARBALL)

distclean:: clean
	ocaml setup.ml -distclean
	$(RM) $(wildcard *.ba[0-9] *.bak *~ *.odocl)

.PHONY: configure all byte native doc install uninstall reinstall \
	clean distclean
