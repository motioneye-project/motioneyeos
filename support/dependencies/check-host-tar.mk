TAR ?= tar

ifeq (,$(call suitable-host-package,tar,$(TAR)))
DEPENDENCIES_HOST_PREREQ += host-tar
TAR = $(HOST_DIR)/usr/bin/tar
endif

# Since TAR is at least 1.17, it will certainly support --strip-components
TAR_STRIP_COMPONENTS = --strip-components
