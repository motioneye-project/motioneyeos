# we can't use suitable-host-package here because that's not available in
# the context of 'make release'
asciidoc-check-dependencies:
	$(Q)if [ -z "$(shell support/dependencies/check-host-asciidoc.sh)" ]; then \
		echo "You need a sufficiently recent asciidoc on your host" \
			"to generate documents"; \
		exit 1; \
	fi
	$(Q)if [ -z "`which w3m 2>/dev/null`" ]; then \
		echo "You need w3m on your host to generate documents"; \
		exit 1; \
	fi

asciidoc-check-dependencies-pdf:
	$(Q)if [ -z "`which dblatex 2>/dev/null`" ]; then \
		echo "You need dblatex on your host to generate PDF documents"; \
		exit 1; \
	fi

# PDF generation is broken because of a bug in xsltproc program provided
# by libxslt <=1.1.28, which does not honor an option we need to set.
# Fortunately, this bug is already fixed upstream:
#   https://gitorious.org/libxslt/libxslt/commit/5af7ad745323004984287e48b42712e7305de35c
#
# So, bail out when trying to build a PDF using a buggy version of the
# xsltproc program.
#
# So, to overcome this issue and being able to build a PDF, you can
# build xsltproc from its source repository, then run:
#   $ PATH=/path/to/custom-xsltproc/bin:${PATH} make manual
GENDOC_XSLTPROC_IS_BROKEN = \
	$(shell xsltproc --maxvars 0 >/dev/null 2>/dev/null || echo y)

################################################################################
# ASCIIDOC_INNER -- generates the make targets needed to build a specific type of
#                   asciidoc documentation.
#
#  argument 1 is the name of the document and the top-level asciidoc file must
#             have the same name
#  argument 2 is the uppercase name of the document
#  argument 3 is the directory containing the document
#  argument 4 is the type of document to generate (-f argument of a2x)
#  argument 5 is the document type as used in the make target
#  argument 6 is the output file extension for the document type
#  argument 7 is the human text for the document type
#  argument 8 (optional) are extra arguments for a2x
#
# The variable <DOCUMENT_NAME>_SOURCES defines the dependencies.
#
# Since this function will be called from within an $(eval ...)
# all variable references except the arguments must be $$-quoted.
################################################################################
define ASCIIDOC_INNER
$(1): $(1)-$(5)
.PHONY: $(1)-$(5)
$(1)-$(5): $$(O)/docs/$(1)/$(1).$(6)

# Single line, because splitting a foreach is not easy...
asciidoc-check-dependencies-$(5):
$(1)-check-dependencies-$(5): asciidoc-check-dependencies-$(5)
	$$(Q)$$(foreach hook,$$($(2)_CHECK_DEPENDENCIES_$$(call UPPERCASE,$(5))_HOOKS),$$(call $$(hook))$$(sep))

$(2)_$(4)_ASCIIDOC_CONF = $(3)/asciidoc-$(4).conf
ifneq ($$(wildcard $$($(2)_$(4)_ASCIIDOC_CONF)),)
$(2)_$(4)_ASCIIDOC_OPTS += -f $$($(2)_$(4)_ASCIIDOC_CONF)
endif

# Handle a2x warning about --destination-dir option only applicable to HTML
# based outputs. So:
# - use the --destination-dir option if possible (html and split-html),
# - otherwise copy the generated document to the output directory
$(2)_$(4)_A2X_OPTS =
ifneq ($$(filter $(5),html split-html),)
$(2)_$(4)_A2X_OPTS += --destination-dir="$$(@D)"
else
define $(2)_$(4)_INSTALL_CMDS
	$$(Q)cp -f $$(BUILD_DIR)/docs/$(1)/$(1).$(6) $$(@D)
endef
endif

ifeq ($(6)-$$(GENDOC_XSLTPROC_IS_BROKEN),pdf-y)
$$(O)/docs/$(1)/$(1).$(6):
	$$(warning PDF generation is disabled because of a bug in \
		xsltproc. To be able to generate a PDF, you should \
		build xsltproc from the libxslt sources >=1.1.29 and pass it \
		to make through the command line: \
		'PATH=/path/to/custom-xsltproc/bin:$$$${PATH} make $(1)-pdf')
else
# -r $(@D) is there for documents that use external filters; those filters
# generate code at the same location it finds the document's source files.
$$(O)/docs/$(1)/$(1).$(6): $$($(2)_SOURCES) \
			   $(1)-check-dependencies \
			   $(1)-check-dependencies-$(5) \
			   $(1)-prepare-sources
	$$(Q)$$(call MESSAGE,"Generating $(7) $(1)...")
	$$(Q)mkdir -p $$(@D)
	$$(Q)a2x $(8) -f $(4) -d book -L \
		$$(foreach r,$$($(2)_RESOURCES),-r $$(r)) -r $$(@D) \
		$$($(2)_$(4)_A2X_OPTS) \
		--asciidoc-opts="$$($(2)_$(4)_ASCIIDOC_OPTS)" \
		$$(BUILD_DIR)/docs/$(1)/$(1).txt
# install the generated document
	$$($(2)_$(4)_INSTALL_CMDS)
endif
endef

################################################################################
# ASCIIDOC -- generates the make targets needed to build asciidoc documentation.
#
# The variable <DOCUMENT_NAME>_SOURCES defines the dependencies.
# The variable <DOCUMENT_NAME>_RESOURCES defines where the document's
# resources, such as images, are located; must be an absolute path.
################################################################################
define ASCIIDOC
# Single line, because splitting a foreach is not easy...
$(pkgname)-check-dependencies: asciidoc-check-dependencies
	$$(Q)$$(foreach hook,$$($$(call UPPERCASE,$(pkgname))_CHECK_DEPENDENCIES_HOOKS),$$(call $$(hook))$$(sep))

$$(BUILD_DIR)/docs/$(pkgname):
	$$(Q)mkdir -p $$@

# Single line, because splitting a foreach is not easy...
$(pkgname)-rsync: $$(BUILD_DIR)/docs/$(pkgname)
	$$(Q)$$(call MESSAGE,"Preparing the $(pkgname) sources...")
	$$(Q)rsync -a $(pkgdir) $$^
	$$(Q)$$(foreach hook,$$($$(call UPPERCASE,$(pkgname))_POST_RSYNC_HOOKS),$$(call $$(hook))$$(sep))

$(pkgname)-prepare-sources: $(pkgname)-rsync

$(call ASCIIDOC_INNER,$(pkgname),$$(call UPPERCASE,$(pkgname)),$(pkgdir),xhtml,html,html,HTML,\
	--xsltproc-opts "--stringparam toc.section.depth 1")

$(call ASCIIDOC_INNER,$(pkgname),$$(call UPPERCASE,$(pkgname)),$(pkgdir),chunked,split-html,chunked,split HTML,\
	--xsltproc-opts "--stringparam toc.section.depth 1")

# dblatex needs to pass the '--maxvars ...' option to xsltproc to prevent it
# from reaching the template recursion limit when processing the (long) target
# package table and bailing out.
$(call ASCIIDOC_INNER,$(pkgname),$$(call UPPERCASE,$(pkgname)),$(pkgdir),pdf,pdf,pdf,PDF,\
	--dblatex-opts "-P latex.output.revhistory=0 -x '--maxvars 100000'")

$(call ASCIIDOC_INNER,$(pkgname),$$(call UPPERCASE,$(pkgname)),$(pkgdir),text,text,text,text)

$(call ASCIIDOC_INNER,$(pkgname),$$(call UPPERCASE,$(pkgname)),$(pkgdir),epub,epub,epub,ePUB)

clean: $(pkgname)-clean
$(pkgname)-clean:
	$$(Q)$$(RM) -rf $$(BUILD_DIR)/docs/$(pkgname)
.PHONY: $(pkgname) $(pkgname)-clean
endef

################################################################################
# asciidoc-document -- the target generator macro for asciidoc documents
################################################################################

asciidoc-document = $(call ASCIIDOC)
