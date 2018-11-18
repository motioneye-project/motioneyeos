ifeq (,$(call suitable-host-package,lzip,$(LZCAT)))
BR2_LZIP_HOST_DEPENDENCY = host-lzip
EXTRACTOR_DEPENDENCY_PRECHECKED_EXTENSIONS += .lz
LZCAT = $(HOST_DIR)/bin/lzip -d -c
endif
