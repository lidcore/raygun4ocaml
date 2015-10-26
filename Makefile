.PHONY: all install-deps clean

# Config
PACKAGES := atdgen extunix ssl lwt cohttp
SUBDIRS := src
ATDGEN := atdgen
OCAMLFIND := ocamlfind
OCAMLOPT := $(OCAMLFIND) ocamlopt
OCAMLDEP := $(OCAMLFIND) ocamldep
OCAMLFLAGS := -g -package atdgen -package extunix -package cohttp.lwt $(SUBDIRS:%=-I %)
x := cmx
i := cmi
V := @

SOURCES := src/raygun_t.mli src/raygun_t.ml \
           src/raygun_j.mli src/raygun_j.ml \
           src/raygun.mli src/raygun.ml

all: $(SOURCES:.ml=.$(x))

install-deps:
	opam install $(PACKAGES)

.depend: $(SOURCES)
	$(V)echo OCAMLDEP
	$(V)$(OCAMLDEP) $(SUBDIRS:%=-I %) $(^) > $(@)

src/raygun_t.mli src/raygun_t.ml: src/raygun.atd
	$(V)echo ATDGEN -t rc/raygun.atd
	$(V)$(ATDGEN) -t src/raygun.atd

src/raygun_j.mli src/raygun_j.ml: src/raygun.atd
	$(V)echo ATDGEN -j rc/raygun.atd
	$(V)$(ATDGEN) -j src/raygun.atd

%.$(i): %.mli
	$(V)echo OCAMLOPT -c $(<)
	$(V)$(OCAMLOPT) $(OCAMLFLAGS) -c $(<)

%.$(x): %.ml
	$(V)echo OCAMLOPT -c $(<)
	$(V)$(OCAMLOPT) $(OCAMLFLAGS) -c $(<)

clean:
	rm -f .depend src/raygun_*.ml*
	find . -name '*.o' -exec rm \{\} \;	
	find . -name '*.a' -exec rm \{\} \;
	find . -name '*.cm*' -exec rm \{\} \;

-include .depend
