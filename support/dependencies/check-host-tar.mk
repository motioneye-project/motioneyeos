TAR ?= tar

ifeq (,$(call suitable-host-package,tar,$(TAR)))
DEPENDENCIES_HOST_PREREQ += host-tar
TAR = $(HOST_DIR)/bin/tar
endif
