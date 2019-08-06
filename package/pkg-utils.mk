################################################################################
#
# This file contains various utility functions used by the package
# infrastructure, or by the packages themselves.
#
################################################################################

#
# Manipulation of .config files based on the Kconfig
# infrastructure. Used by the BusyBox package, the Linux kernel
# package, and more.
#

define KCONFIG_ENABLE_OPT # (option, file)
	$(SED) "/\\<$(1)\\>/d" $(2)
	echo '$(1)=y' >> $(2)
endef

define KCONFIG_SET_OPT # (option, value, file)
	$(SED) "/\\<$(1)\\>/d" $(3)
	echo '$(1)=$(2)' >> $(3)
endef

define KCONFIG_DISABLE_OPT # (option, file)
	$(SED) "/\\<$(1)\\>/d" $(2)
	echo '# $(1) is not set' >> $(2)
endef

# Helper functions to determine the name of a package and its
# directory from its makefile directory, using the $(MAKEFILE_LIST)
# variable provided by make. This is used by the *-package macros to
# automagically find where the package is located.
pkgdir = $(dir $(lastword $(MAKEFILE_LIST)))
pkgname = $(lastword $(subst /, ,$(pkgdir)))

# Define extractors for different archive suffixes
INFLATE.bz2  = $(BZCAT)
INFLATE.gz   = $(ZCAT)
INFLATE.lz   = $(LZCAT)
INFLATE.lzma = $(XZCAT)
INFLATE.tbz  = $(BZCAT)
INFLATE.tbz2 = $(BZCAT)
INFLATE.tgz  = $(ZCAT)
INFLATE.xz   = $(XZCAT)
INFLATE.tar  = cat
# suitable-extractor(filename): returns extractor based on suffix
suitable-extractor = $(INFLATE$(suffix $(1)))

# extractor-dependency(filename): returns extractor for 'filename' if the
# extractor is a dependency. If we build the extractor return nothing.
# $(firstword) is used here because the extractor can have arguments, like
# ZCAT="gzip -d -c", and to check for the dependency we only want 'gzip'.
extractor-dependency = $(firstword $(INFLATE$(filter-out \
	$(EXTRACTOR_DEPENDENCY_PRECHECKED_EXTENSIONS),$(suffix $(1)))))

# check-deprecated-variable -- throw an error on deprecated variables
# example:
#   $(eval $(call check-deprecated-variable,FOO_MAKE_OPT,FOO_MAKE_OPTS))
define check-deprecated-variable # (deprecated var, new var)
ifneq ($$(origin $(1)),undefined)
$$(error Package error: use $(2) instead of $(1). Please fix your .mk file)
endif
endef

# $(1): YES or NO
define yesno-to-bool
	$(subst NO,false,$(subst YES,true,$(1)))
endef

# json-info -- return package or filesystem metadata formatted as an entry
#              of a JSON dictionnary
# $(1): upper-case package or filesystem name
define json-info
	"$($(1)_NAME)": {
		"type": "$($(1)_TYPE)",
		$(if $(filter rootfs,$($(1)_TYPE)), \
			$(call _json-info-fs,$(1)), \
			$(call _json-info-pkg,$(1)), \
		)
	}
endef

# _json-info-pkg, _json-info-pkg-details, _json-info-fs: private helpers
# for json-info, above
define _json-info-pkg
	$(if $($(1)_IS_VIRTUAL), \
		"virtual": true$(comma),
		"virtual": false$(comma)
		$(call _json-info-pkg-details,$(1)) \
	)
	"dependencies": [
		$(call make-comma-list,$(sort $($(1)_FINAL_ALL_DEPENDENCIES)))
	],
	"reverse_dependencies": [
		$(call make-comma-list,$(sort $($(1)_RDEPENDENCIES)))
	]
endef

define _json-info-pkg-details
	"version": "$($(1)_DL_VERSION)",
	"licenses": "$($(1)_LICENSE)",
	"install_target": $(call yesno-to-bool,$($(1)_INSTALL_TARGET)),
	"install_staging": $(call yesno-to-bool,$($(1)_INSTALL_STAGING)),
	"install_images": $(call yesno-to-bool,$($(1)_INSTALL_IMAGES)),
	"downloads": [
	$(foreach dl,$(sort $($(1)_ALL_DOWNLOADS)),
		{
			"source": "$(notdir $(dl))",
			"uris": [
				$(call make-comma-list,
					$(subst \|,|,
						$(call DOWNLOAD_URIS,$(dl),$(1))
					)
				)
			]
		},
	)
	],
endef

define _json-info-fs
	"dependencies": [
		$(call make-comma-list,$(sort $($(1)_DEPENDENCIES)))
	]
endef

# clean-json -- cleanup pseudo-json into clean json:
#  - remove commas before closing ] and }
#  - minify with $(strip)
clean-json = $(strip \
	$(subst $(comma)},}, $(subst $(comma)$(space)},$(space)}, \
	$(subst $(comma)],], $(subst $(comma)$(space)],$(space)], \
		$(strip $(1)) \
	)))) \
)

#
# legal-info helper functions
#
LEGAL_INFO_SEPARATOR = "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"

define legal-warning # text
	echo "WARNING: $(1)" >>$(LEGAL_WARNINGS)
endef

define legal-warning-pkg # pkg, text
	echo "WARNING: $(1): $(2)" >>$(LEGAL_WARNINGS)
endef

define legal-warning-nosource # pkg, {local|override}
	$(call legal-warning-pkg,$(1),sources not saved ($(2) packages not handled))
endef

define legal-manifest # {HOST|TARGET}, pkg, version, license, license-files, source, url, dependencies
	echo '"$(2)","$(3)","$(4)","$(5)","$(6)","$(7)","$(8)"' >>$(LEGAL_MANIFEST_CSV_$(1))
endef

define legal-license-file # pkgname, pkgname-pkgver, pkg-hashfile, filename, file-fullpath, {HOST|TARGET}
	mkdir -p $(LICENSE_FILES_DIR_$(6))/$(2)/$(dir $(4)) && \
	{ \
		support/download/check-hash $(3) $(5) $(4); \
		case $${?} in (0|3) ;; (*) exit 1;; esac; \
	} && \
	cp $(5) $(LICENSE_FILES_DIR_$(6))/$(2)/$(4)
endef

non-virtual-deps = $(foreach p,$(1),$(if $($(call UPPERCASE,$(p))_IS_VIRTUAL),,$(p)))

# Returns the list of recursive dependencies and their licensing terms
# for the package specified in parameter (in lowercase). If that
# package is a target package, remove host packages from the list.
legal-deps = \
    $(foreach p,\
        $(filter-out $(if $(1:host-%=),host-%),\
            $(call non-virtual-deps,\
                $($(call UPPERCASE,$(1))_FINAL_RECURSIVE_DEPENDENCIES))),$(p) [$($(call UPPERCASE,$(p))_LICENSE)])
