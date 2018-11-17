ifeq (,$(call suitable-host-package,gzip))
BR2_GZIP_HOST_DEPENDENCY = host-gzip
endif
