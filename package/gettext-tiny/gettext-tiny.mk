################################################################################
#
# gettext-tiny
#
################################################################################

GETTEXT_TINY_VERSION = adaa9c64921e80f2b8dd3610ffb508618b9204f3
GETTEXT_TINY_SITE = $(call github,sabotage-linux,gettext-tiny,$(GETTEXT_TINY_VERSION))
GETTEXT_TINY_LICENSE = MIT, GPL-3.0+ (extra gettext)
GETTEXT_TINY_INSTALL_STAGING = YES
GETTEXT_TINY_LICENSE_FILES = LICENSE
HOST_GETTEXT_TINY_LICENSE_FILES = LICENSE extra/COPYING

GETTEXT_TINY_PROVIDES = gettext

# needed for gettextize
GETTEXT_TINY_ARCHIVE_VERSION = 0.19.8

GETTEXT_TINY_EXTRA_GETTEXT_FILES = \
	gettext-tools/misc/gettextize.in \
	gettext-tools/po/Makevars.template \
	gettext-runtime/m4/lock.m4 \
	gettext-runtime/po/boldquot.sed \
	gettext-runtime/po/en@boldquot.header \
	gettext-runtime/po/en@quot.header \
	gettext-runtime/po/insert-header.sin \
	gettext-runtime/po/quot.sed \
	gettext-runtime/po/remove-potcdate.sin \
	gettext-runtime/po/Rules-quot \
	gettext-runtime/po/Makefile.in.in \
	COPYING

HOST_GETTEXT_TINY_EXTRA_DOWNLOADS = $(GETTEXT_GNU_SITE)/$(GETTEXT_GNU_SOURCE)

define HOST_GETTEXT_TINY_EXTRACT_GNU_GETTEXT
	mkdir -p $(@D)/gettext-gnu
	$(call suitable-extractor,$(GETTEXT_GNU_SOURCE)) \
		$(GETTEXT_TINY_DL_DIR)/$(GETTEXT_GNU_SOURCE) | \
		$(TAR) --strip-components=1 -C $(@D)/gettext-gnu $(TAR_OPTIONS) -
endef
HOST_GETTEXT_TINY_POST_EXTRACT_HOOKS += HOST_GETTEXT_TINY_EXTRACT_GNU_GETTEXT

define HOST_GETTEXT_TINY_COPY_EXTRA_FILES
	$(foreach f,$(GETTEXT_TINY_EXTRA_GETTEXT_FILES),\
		$(INSTALL) -D -m 0644 $(@D)/gettext-gnu/$(f) $(@D)/extra/$(notdir $(f))
	)
	$(INSTALL) -D -m 0755 $(@D)/gettext-gnu/build-aux/config.rpath \
		$(@D)/build-aux/config.rpath
endef
HOST_GETTEXT_TINY_POST_PATCH_HOOKS += HOST_GETTEXT_TINY_COPY_EXTRA_FILES

define HOST_GETTEXT_TINY_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) \
		$(HOST_CONFIGURE_OPTS) \
		prefix=$(HOST_DIR) \
		CFLAGS="$(HOST_CFLAGS) -fPIC" \
		LIBINTL=NONE

	cp $(@D)/extra/gettextize.in $(@D)/gettextize

	$(SED) 's,@PACKAGE@,gettext-tools,g;' $(@D)/gettextize
	$(SED) 's,@VERSION@,$(GETTEXT_GNU_VERSION),g;' $(@D)/gettextize
	$(SED) 's,@ARCHIVE_VERSION@,$(GETTEXT_TINY_ARCHIVE_VERSION),' $(@D)/gettextize
	$(SED) 's,@prefix@,$(HOST_DIR),g;' $(@D)/gettextize
	$(SED) 's,@datarootdir@,$${prefix}/share,g;' $(@D)/gettextize
	$(SED) 's,@datadir@,$${prefix}/share,g;' $(@D)/gettextize
	$(SED) 's,@PATH_SEPARATOR@,:,g;' $(@D)/gettextize
	$(SED) 's,@RELOCATABLE@,no,g;' $(@D)/gettextize
	$(SED) 's,@exec_prefix@,$${prefix},g;' $(@D)/gettextize
	$(SED) 's,@bindir@,$${exec_prefix}/bin,g;' $(@D)/gettextize
endef

define HOST_GETTEXT_TINY_INSTALL_CMDS
	$(Q)mkdir -p $(HOST_DIR)/share/gettext-tiny/po
	$(Q)mkdir -p $(HOST_DIR)/share/gettext-tiny/m4

	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) \
		$(HOST_CONFIGURE_OPTS) \
		prefix=$(HOST_DIR) \
		LIBINTL=NONE install

	$(SED) '/read dummy/d' $(@D)/gettextize

	$(INSTALL) -m 0755 -D $(@D)/gettextize $(HOST_DIR)/bin/gettextize
	$(INSTALL) -m 0644 -D $(@D)/build-aux/config.rpath $(HOST_DIR)/share/gettext-tiny/config.rpath
	$(INSTALL) -m 0644 -D $(@D)/extra/lock.m4 $(HOST_DIR)/share/gettext-tiny/m4/lock.m4
	$(INSTALL) -m 0644 -D $(@D)/extra/Makefile.in.in $(HOST_DIR)/share/gettext-tiny/po/Makefile.in.in
	$(INSTALL) -m 0644 -D $(@D)/extra/boldquot.sed $(HOST_DIR)/share/gettext-tiny/po/boldquot.sed
	$(INSTALL) -m 0644 -D $(@D)/extra/en@boldquot.header $(HOST_DIR)/share/gettext-tiny/po/en@boldquot.header
	$(INSTALL) -m 0644 -D $(@D)/extra/en@quot.header $(HOST_DIR)/share/gettext-tiny/po/en@quot.header
	$(INSTALL) -m 0644 -D $(@D)/extra/insert-header.sin $(HOST_DIR)/share/gettext-tiny/po/insert-header.sin
	$(INSTALL) -m 0644 -D $(@D)/extra/quot.sed $(HOST_DIR)/share/gettext-tiny/po/quot.sed
	$(INSTALL) -m 0644 -D $(@D)/extra/remove-potcdate.sin $(HOST_DIR)/share/gettext-tiny/po/remove-potcdate.sin
	$(INSTALL) -m 0644 -D $(@D)/extra/Rules-quot $(HOST_DIR)/share/gettext-tiny/po/Rules-quot
	$(INSTALL) -m 0644 -D $(@D)/extra/Makevars.template $(HOST_DIR)/share/gettext-tiny/po/Makevars.template

	$(Q)touch $(HOST_DIR)/share/gettext-tiny/ABOUT-NLS

	# for gettextize
	ln -sf $(HOST_DIR)/usr/share/gettext-tiny $(HOST_DIR)/usr/share/gettext
endef

# Install simple echo wrapper for gettext tool
define GETTEXT_TINY_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(GETTEXT_TINY_PKGDIR)/gettext-wrapper $(TARGET_DIR)/usr/bin/gettext
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
