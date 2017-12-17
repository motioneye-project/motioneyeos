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

# Apply this configuration to all documents
BR_ASCIIDOC_CONF = docs/conf/asciidoc.conf

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

# Include Buildroot's AsciiDoc configuration first:
#  - generic configuration,
#  - then output-specific configuration
ifneq ($$(wildcard $$(BR_ASCIIDOC_CONF)),)
$(2)_$(4)_ASCIIDOC_OPTS += -f $$(BR_ASCIIDOC_CONF)
endif
BR_$(4)_ASCIIDOC_CONF = docs/conf/asciidoc-$(4).conf
ifneq ($$(wildcard $$(BR_$(4)_ASCIIDOC_CONF)),)
$(2)_$(4)_ASCIIDOC_OPTS += -f $$(BR_$(4)_ASCIIDOC_CONF)
endif

# Then include the document's AsciiDoc configuration:
#  - generic configuration,
#  - then output-specific configuration
ifneq ($$(wildcard $$($(2)_ASCIIDOC_CONF)),)
$(2)_$(4)_ASCIIDOC_OPTS += -f $$($(2)_ASCIIDOC_CONF)
endif
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

$$(O)/docs/$(1)/$(1).$(6): export TZ=UTC

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
		$$(foreach r,$$($(2)_RESOURCES) $$(@D), \
			--resource="$$(abspath $$(r))") \
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
# argument 1 is the lowercase name of the document; the document's main file
#            must have the same name, with the .txt extension
# argument 2 is the uppercase name of the document
# argument 3 is the directory containing the document's sources
#
# The variable <DOCUMENT_NAME>_SOURCES defines the dependencies.
# The variable <DOCUMENT_NAME>_RESOURCES defines where the document's
# resources, such as images, are located; must be an absolute path.
################################################################################
define ASCIIDOC
# Single line, because splitting a foreach is not easy...
$(1)-check-dependencies: asciidoc-check-dependencies $$($(2)_DEPENDENCIES)
	$$(Q)$$(foreach hook,$$($(2)_CHECK_DEPENDENCIES_HOOKS),$$(call $$(hook))$$(sep))

# Single line, because splitting a foreach is not easy...
# Do not touch the stamp file, so we get to rsync again every time we build
# the document.
$$(BUILD_DIR)/docs/$(1)/.stamp_doc_rsynced:
	$$(Q)$$(call MESSAGE,"Preparing the $(1) sources...")
	$$(Q)mkdir -p $$(@D)
	$$(Q)rsync -a $(3) $$(@D)
	$$(Q)$$(foreach hook,$$($(2)_POST_RSYNC_HOOKS),$$(call $$(hook))$$(sep))

$(1)-prepare-sources: $$(BUILD_DIR)/docs/$(1)/.stamp_doc_rsynced

$(2)_ASCIIDOC_CONF = $(3)/asciidoc.conf

$(call ASCIIDOC_INNER,$(1),$(2),$(3),xhtml,html,html,HTML,\
	--xsltproc-opts "--stringparam toc.section.depth 1")

$(call ASCIIDOC_INNER,$(1),$(2),$(3),chunked,split-html,chunked,split HTML,\
	--xsltproc-opts "--stringparam toc.section.depth 1")

# dblatex needs to pass the '--maxvars ...' option to xsltproc to prevent it
# from reaching the template recursion limit when processing the (long) target
# package table and bailing out.
$(call ASCIIDOC_INNER,$(1),$(2),$(3),pdf,pdf,pdf,PDF,\
	--dblatex-opts "-P latex.output.revhistory=0 -x '--maxvars 100000'")

$(call ASCIIDOC_INNER,$(1),$(2),$(3),text,text,text,text)

$(call ASCIIDOC_INNER,$(1),$(2),$(3),epub,epub,epub,ePUB)

clean: $(1)-clean
$(1)-clean:
	$$(Q)$$(RM) -rf $$(BUILD_DIR)/docs/$(1)
.PHONY: $(1) $(1)-clean
endef

################################################################################
# asciidoc-document -- the target generator macro for asciidoc documents
################################################################################

asciidoc-document = $(call ASCIIDOC,$(pkgname),$(call UPPERCASE,$(pkgname)),$(pkgdir))
