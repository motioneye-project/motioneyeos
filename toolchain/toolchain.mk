################################################################################
#
# toolchain-related customisation of the content of the target/ directory
#
################################################################################

# Those customisations are added to the TARGET_FINALIZE_HOOKS, to be applied
# just after all packages have been built.

# Install the gconv modules
ifeq ($(BR2_TOOLCHAIN_GLIBC_GCONV_LIBS_COPY),y)
TOOLCHAIN_GLIBC_GCONV_LIBS = $(call qstrip,$(BR2_TOOLCHAIN_GLIBC_GCONV_LIBS_LIST))
define TOOLCHAIN_GLIBC_COPY_GCONV_LIBS
	$(Q)found_gconv=no; \
	for d in $(TOOLCHAIN_EXTERNAL_PREFIX) ''; do \
		[ -d "$(STAGING_DIR)/usr/lib/$${d}/gconv" ] || continue; \
		found_gconv=yes; \
		break; \
	done; \
	if [ "$${found_gconv}" = "no" ]; then \
		printf "Unable to find gconv modules\n" >&2; \
		exit 1; \
	fi; \
	if [ -z "$(TOOLCHAIN_GLIBC_GCONV_LIBS)" ]; then \
		$(INSTALL) -m 0644 -D $(STAGING_DIR)/usr/lib/$${d}/gconv/gconv-modules \
				      $(TARGET_DIR)/usr/lib/gconv/gconv-modules && \
		$(INSTALL) -m 0644 $(STAGING_DIR)/usr/lib/$${d}/gconv/*.so \
				   $(TARGET_DIR)/usr/lib/gconv \
		|| exit 1; \
	else \
		for l in $(TOOLCHAIN_GLIBC_GCONV_LIBS); do \
			$(INSTALL) -m 0644 -D $(STAGING_DIR)/usr/lib/$${d}/gconv/$${l}.so \
					      $(TARGET_DIR)/usr/lib/gconv/$${l}.so \
			|| exit 1; \
			$(TARGET_READELF) -d $(STAGING_DIR)/usr/lib/$${d}/gconv/$${l}.so |\
			sort -u |\
			sed -e '/.*(NEEDED).*\[\(.*\.so\)\]$$/!d; s//\1/;' |\
			while read lib; do \
				 $(INSTALL) -m 0644 -D $(STAGING_DIR)/usr/lib/$${d}/gconv/$${lib} \
						       $(TARGET_DIR)/usr/lib/gconv/$${lib} \
				 || exit 1; \
			done; \
		done; \
		./support/scripts/expunge-gconv-modules "$(TOOLCHAIN_GLIBC_GCONV_LIBS)" \
			<$(STAGING_DIR)/usr/lib/$${d}/gconv/gconv-modules \
			>$(TARGET_DIR)/usr/lib/gconv/gconv-modules; \
	fi
endef
TOOLCHAIN_TARGET_FINALIZE_HOOKS += TOOLCHAIN_GLIBC_COPY_GCONV_LIBS
endif
