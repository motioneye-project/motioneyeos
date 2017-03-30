################################################################################
#
# sp-oops-extract
#
################################################################################

SP_OOPS_EXTRACT_VERSION = 0.0.7-1
SP_OOPS_EXTRACT_SITE = http://repository.maemo.org/pool/maemo5.0/free/s/sp-oops-extract
SP_OOPS_EXTRACT_SOURCE = sp-oops-extract_$(SP_OOPS_EXTRACT_VERSION).tar.gz
SP_OOPS_EXTRACT_LICENSE = GPL-2.0
SP_OOPS_EXTRACT_LICENSE_FILES = COPYING

define SP_OOPS_EXTRACT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define SP_OOPS_EXTRACT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install \
		DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
