################################################################################
#
# cvs
#
################################################################################

CVS_VERSION = 1.12.13
CVS_SOURCE = cvs_$(CVS_VERSION).orig.tar.gz
CVS_PATCH = cvs_$(CVS_VERSION)-12.diff.gz
CVS_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/c/cvs/
CVS_DEPENDENCIES = ncurses

CVS_CONF_ENV = cvs_cv_func_printf_ptr=yes

CVS_CONFIGURE_ARGS = --disable-old-info-format-support
ifeq ($(BR2_PACKAGE_CVS_SERVER),y)
CVS_CONFIGURE_ARGS += --enable-server
else
CVS_CONFIGURE_ARGS += --disable-server
endif
ifeq ($(BR2_PACKAGE_ZLIB),y)
CVS_CONFIGURE_ARGS += --with-external-zlib
endif

CVS_CONF_OPT = $(CVS_CONFIGURE_ARGS)

define CVS_BZIP_UNPACK
	$(BZCAT) $(@D)/cvs-$(CVS_VERSION).tar.bz2 | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	rm -f $(@D)/cvs-$(CVS_VERSION).tar.bz2
endef

CVS_POST_PATCH_HOOKS += CVS_BZIP_UNPACK

ifneq ($(CVS_PATCH),)
define CVS_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		(cd $(@D)/debian/patches && for i in *; \
		 do $(SED) 's,^\+\+\+ .*cvs-$(CVS_VERSION)/,+++ cvs-$(CVS_VERSION)/,' $$i; \
		 done; \
		); \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches \*; \
	fi
endef
endif

CVS_POST_PATCH_HOOKS += CVS_DEBIAN_PATCHES

define CVS_INSTALL_TARGET_CMDS
	install -D $(@D)/src/cvs $(TARGET_DIR)/usr/bin/cvs
endef

$(eval $(autotools-package))
