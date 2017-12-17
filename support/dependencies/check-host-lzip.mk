ifeq (,$(call suitable-host-package,lzip,$(LZCAT)))
DEPENDENCIES_HOST_PREREQ += host-lzip
EXTRACTOR_DEPENDENCY_PRECHECKED_EXTENSIONS += .lz
LZCAT = $(HOST_DIR)/bin/lzip -d -c
endif
