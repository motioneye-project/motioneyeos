# Since version 2.28, glibc requires GNU Make >= 4.0
# https://www.sourceware.org/ml/libc-alpha/2018-08/msg00003.html
#
# Set this to either 4.0 or higher, depending on the highest minimum
# version required by any of the packages bundled in Buildroot. If a
# package is bumped or a new one added, and it requires a higher
# version, our package infra will catch it and whine.
#
BR2_MAKE_VERSION_MIN = 4.0

BR2_MAKE ?= $(call suitable-host-package,make,\
	$(BR2_MAKE_VERSION_MIN) $(MAKE))

ifeq ($(BR2_MAKE),)
BR2_MAKE = $(HOST_DIR)/bin/host-make -j$(PARALLEL_JOBS)
BR2_MAKE1 = $(HOST_DIR)/bin/host-make -j1
BR2_MAKE_HOST_DEPENDENCY = host-make
else
BR2_MAKE = $(MAKE)
BR2_MAKE1 = $(MAKE1)
endif
