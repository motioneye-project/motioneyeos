#############################################################
#
# portage
#
#############################################################
PORTAGE_DOWNLOAD_VERSION:=2.1.2
PORTAGE_PATCH_VERSION:=.9
PORTAGE_VERSION:=$(PORTAGE_DOWNLOAD_VERSION)$(PORTAGE_PATCH_VERSION)
PORTAGE_PATCH:=portage-$(PORTAGE_VERSION).patch.bz2

PORTAGE_SOURCE:=portage-$(PORTAGE_DOWNLOAD_VERSION).tar.bz2
PORTAGE_SITE:=http://gentoo.osuosl.org/distfiles
PORTAGE_CAT:=$(BZCAT)
PORTAGE_DIR:=$(BUILD_DIR)/portage-$(PORTAGE_VERSION)
PORTAGE_TARGET_DIR:=$(TARGET_DIR)/usr/lib/portage
PORTAGE_TARGET_BINARY:=usr/bin/emerge

SANDBOX_VERSION:=1.2.18.1
SANDBOX_SOURCE:=sandbox-$(SANDBOX_VERSION).tar.bz2
SANDBOX_SITE:=http://dev.gentoo.org/~azarah/sandbox/
#SANDBOX_SITE:=$(PORTAGE_SITE)
SANDBOX_CAT:=$(PORTAGE_CAT)
SANDBOX_DIR:=$(BUILD_DIR)/sandbox-$(SANDBOX_VERSION)
SANDBOX_TARGET_BINARY:=usr/bin/sandbox

ifeq ($(BR2_cris),y)
	PORTAGE_ARCH:=x86
endif
ifeq ($(BR2_mipsel),y)
	PORTAGE_ARCH:=mips
endif
ifeq ($(BR2_powerpc),y)
	PORTAGE_ARCH:=ppc
endif
ifeq ($(BR2_sh4),y)
	PORTAGE_ARCH:=sh
endif
ifeq ($(BR2_sh64),y)
	PORTAGE_ARCH:=sh
endif
ifeq ($(BR2_i386),y)
	PORTAGE_ARCH:=x86
endif
ifeq ($(PORTAGE_ARCH),)
	PORTAGE_ARCH:=$(ARCH)
endif

$(DL_DIR)/$(PORTAGE_SOURCE):
	$(WGET) -P $(DL_DIR) $(PORTAGE_SITE)/$(PORTAGE_SOURCE)
$(DL_DIR)/$(PORTAGE_PATCH):
	$(WGET) -P $(DL_DIR) $(PORTAGE_SITE)/$(PORTAGE_PATCH)
$(DL_DIR)/$(SANDBOX_SOURCE):
	$(WGET) -P $(DL_DIR) $(SANDBOX_SITE)/$(SANDBOX_SOURCE)

portage-source: $(DL_DIR)/$(PORTAGE_SOURCE)
sandbox-source: $(DL_DIR)/$(SANDBOX_SOURCE)

$(PORTAGE_DIR)/.unpacked: $(DL_DIR)/$(PORTAGE_SOURCE)
	$(PORTAGE_CAT) $(DL_DIR)/$(PORTAGE_SOURCE) | tar -C $(BUILD_DIR) -xf -
	mv -f $(BUILD_DIR)/portage-$(PORTAGE_DOWNLOAD_VERSION) $(PORTAGE_DIR)
	rm -f $(PORTAGE_DIR)/bin/tbz2tool
	touch $@

$(PORTAGE_DIR)/.patched: $(PORTAGE_DIR)/.unpacked $(DL_DIR)/$(PORTAGE_PATCH)
	(cd $(PORTAGE_DIR); $(PORTAGE_CAT) $(DL_DIR)/$(PORTAGE_PATCH) | patch -p0)
	touch $@

$(SANDBOX_DIR)/.unpacked: $(DL_DIR)/$(SANDBOX_SOURCE)
	$(SANDBOX_CAT) $(DL_DIR)/$(SANDBOX_SOURCE) | tar -C $(BUILD_DIR) -xf -
	touch $@

$(PORTAGE_DIR)/.compiled: $(PORTAGE_DIR)/.patched
	$(TARGET_CC) $(TARGET_CFLAGS) $(PORTAGE_DIR)/src/tbz2tool.c -o $(PORTAGE_DIR)/src/tbz2tool
	touch $@

$(SANDBOX_DIR)/.compiled: $(SANDBOX_DIR)/.unpacked
	touch $@

newins=install -D
doins=install
dodir=install -d
doexe=install -D -m 755
dosym=ln -sf
$(TARGET_DIR)/$(PORTAGE_TARGET_BINARY): $(PORTAGE_DIR)/.compiled
	(cd $(PORTAGE_DIR)/cnf; \
		$(newins) make.globals $(TARGET_DIR)/etc/make.globals; \
		$(newins) make.conf $(TARGET_DIR)/etc/make.conf; \
		cp $(TARGET_DIR)/etc/make.conf $(TARGET_DIR)/etc/make.conf.$(PORTAGE_ARCH); \
		patch $(TARGET_DIR)/etc/make.conf.$(PORTAGE_ARCH) $(PORTAGE_DIR)/cnf/make.conf.$(PORTAGE_ARCH).diff; \
		$(doins) etc-update.conf dispatch-conf.conf $(TARGET_DIR)/etc; \
	)
# $(newins) make.globals.$(PORTAGE_ARCH) $(TARGET_DIR)/etc/make.globals; \
# $(newins) make.conf.$(PORTAGE_ARCH) $(TARGET_DIR)/etc/make.conf; \

	$(dodir) $(PORTAGE_TARGET_DIR)/pym
	$(doins) $(PORTAGE_DIR)/pym/*.py $(PORTAGE_TARGET_DIR)/pym/
	mkdir -p $(PORTAGE_TARGET_DIR)/pym/cache
	$(doins) $(PORTAGE_DIR)/pym/cache/*.py $(PORTAGE_TARGET_DIR)/pym
	mkdir -p $(PORTAGE_TARGET_DIR)/pym/elog_modules
	$(doins) $(PORTAGE_DIR)/pym/elog_modules/*.py $(PORTAGE_TARGET_DIR)/pym/elog_modules

	$(dodir) $(PORTAGE_TARGET_DIR)/bin
	$(doexe) $(PORTAGE_DIR)/bin/* $(PORTAGE_DIR)/src/tbz2tool $(PORTAGE_TARGET_DIR)/bin/

	mkdir -p $(TARGET_DIR)/usr/portage/distfiles
	mkdir -p $(TARGET_DIR)/var/lib/portage

	$(dodir) $(PORTAGE_TARGET_DIR)/usr/bin
	$(dodir) $(PORTAGE_TARGET_DIR)/usr/sbin
	$(dosym) newins $(PORTAGE_TARGET_DIR)/bin/donewins
	for sbin in pkgmerge ebuild ebuild.sh etc-update dispatch-conf \
		archive-conf fixpackages env-update regenworld emerge-webrsync; do \
		$(dosym) ../lib/portage/bin/$${sbin} $(TARGET_DIR)/usr/sbin/$${sbin}; \
	done
	for bin in xpak repoman tbz2tool portageq g-cpan.pl quickpkg emerge; do \
		$(dosym) ../lib/portage/bin/$${bin} $(TARGET_DIR)/usr/bin/$${bin}; \
	done
$(TARGET_DIR)/$(SANDBOX_TARGET_BINARY): $(SANDBOX_DIR)/.compiled
	touch $(TARGET_DIR)/$(SANDBOX_TARGET_BINARY)

sandbox: uclibc $(TARGET_DIR)/$(SANDBOX_TARGET_BINARY)
portage: sandbox python uclibc $(TARGET_DIR)/$(PORTAGE_TARGET_BINARY)

portage-clean:
	(cd $(TARGET_DIR)/etc; \
		rm -f make.globals make.conf etc-update.conf dispatch-conf.conf)
	rm -rf $(PORTAGE_TARGET_DIR)

	for sbin in pkgmerge ebuild ebuild.sh etc-update dispatch-conf \
		archive-conf fixpackages env-update regenworld emerge-webrsync; do \
		rm -f $(TARGET_DIR)/usr/sbin/$${sbin}; \
	done
	for bin in xpak repoman tbz2tool portageq g-cpan.pl quickpkg emerge; do \
		rm -f $(TARGET_DIR)/usr/bin/$${bin}; \
	done
sandbox-clean:


portage-dirclean:
	rm -rf $(PORTAGE_DIR)
sandbox-dirclean:
	rm -rf $(SANDBOX_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_PORTAGE)),y)
TARGETS+=portage sandbox
endif
