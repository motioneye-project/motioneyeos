################################################################################
#
# rsh-redone
#
################################################################################

RSH_REDONE_VERSION = 85
RSH_REDONE_SOURCE = rsh-redone_$(RSH_REDONE_VERSION).orig.tar.gz
RSH_REDONE_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/r/rsh-redone
RSH_REDONE_LICENSE = GPL-2.0
RSH_REDONE_LICENSE_FILES = rsh.c

RSH_REDONE_BINS-y =
RSH_REDONE_BINS-$(BR2_PACKAGE_RSH_REDONE_RLOGIN) += rlogin
RSH_REDONE_BINS-$(BR2_PACKAGE_RSH_REDONE_RSH) += rsh
RSH_REDONE_SBINS-y =
RSH_REDONE_SBINS-$(BR2_PACKAGE_RSH_REDONE_RLOGIND) += in.rlogind
RSH_REDONE_SBINS-$(BR2_PACKAGE_RSH_REDONE_RSHD) += in.rshd

RSH_REDONE_MAKE_FLAGS = \
	BIN="$(RSH_REDONE_BINS-y)" SBIN="$(RSH_REDONE_SBINS-y)"

ifneq ($(BR2_PACKAGE_RSH_REDONE_RSHD)$(BR2_PACKAGE_RSH_REDONE_RLOGIND),)
RSH_REDONE_DEPENDENCIES = linux-pam
endif

define RSH_REDONE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(RSH_REDONE_MAKE_FLAGS)
endef

define RSH_REDONE_INSTALL_TARGET_CMDS
	$(if $(RSH_REDONE_BINS-y)$(RSH_REDONE_SBINS-y),
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(RSH_REDONE_MAKE_FLAGS) DESTDIR=$(TARGET_DIR) \
			$(if $(RSH_REDONE_BINS-y),install-bin) \
			$(if $(RSH_REDONE_SBINS-y),install-sbin))
endef

$(eval $(generic-package))
