#############################################################
#
# portage
#
#############################################################
PORTAGE_VERSION:=2.0.51-r15
PORTAGE_SOURCE:=portage-$(PORTAGE_VERSION).tar.bz2
PORTAGE_SITE:=http://gentoo.twobit.net/portage/
PORTAGE_CAT:=bzcat
PORTAGE_DIR:=$(BUILD_DIR)/portage-$(PORTAGE_VERSION)
PORTAGE_TARGET_DIR:=$(TARGET_DIR)/usr/lib/portage
PORTAGE_TARGET_BINARY:=usr/bin/emerge

ifeq ($(ARCH), arm)
	PORTAGE_ARCH:=arm
endif
ifeq ($(ARCH),cris)
	PORTAGE_ARCH:=x86
endif
ifeq ($(ARCH), mips)
	PORTAGE_ARCH:=mips
endif
ifeq ($(ARCH), mipsel)
	PORTAGE_ARCH:=mips
endif
ifeq ($(ARCH), powerpc)
	PORTAGE_ARCH:=ppc
endif
ifeq ($(ARCH),sh4)
	PORTAGE_ARCH:=sh
endif
ifeq ($(ARCH),sh64)
	PORTAGE_ARCH:=sh
endif
ifeq ($(ARCH),sparc)
	PORTAGE_ARCH:=sparc
endif
ifeq ($(ARCH), i386)
	PORTAGE_ARCH:=x86
endif

$(DL_DIR)/$(PORTAGE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(PORTAGE_SITE)/$(PORTAGE_SOURCE)

portage-source: $(DL_DIR)/$(PORTAGE_SOURCE)

$(PORTAGE_DIR)/.unpacked: $(DL_DIR)/$(PORTAGE_SOURCE)
	$(PORTAGE_CAT) $(DL_DIR)/$(PORTAGE_SOURCE) | tar -C $(BUILD_DIR) -xf -
	rm -f $(PORTAGE_DIR)/bin/tbz2tool
	touch $(PORTAGE_DIR)/.unpacked

$(PORTAGE_DIR)/.compiled: $(PORTAGE_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CC) -C $(PORTAGE_DIR)/src/sandbox-1.1
	$(TARGET_CC) $(TARGET_CFLAGS) $(PORTAGE_DIR)/src/tbz2tool.c -o $(PORTAGE_DIR)/src/tbz2tool
	touch $(PORTAGE_DIR)/.compiled

newins=install -D
doins=install
dodir=install -d
doexe=install -D -m 755
dosym=ln -s
$(TARGET_DIR)/$(PORTAGE_TARGET_BINARY): $(PORTAGE_DIR)/.compiled
	(cd $(PORTAGE_DIR)/cnf; \
		$(newins) make.globals $(TARGET_DIR)/etc/make.globals; \
		$(newins) make.globals.$(PORTAGE_ARCH) $(TARGET_DIR)/etc/make.globals; \
		$(newins) make.conf $(TARGET_DIR)/etc/make.conf; \
		$(newins) make.conf.$(PORTAGE_ARCH) $(TARGET_DIR)/etc/make.conf; \
		$(doins) etc-update.conf dispatch-conf.conf $(TARGET_DIR)/etc; \
	)

	$(dodir) $(PORTAGE_TARGET_DIR)/pym
	$(doins) $(PORTAGE_DIR)/pym/* $(PORTAGE_TARGET_DIR)/pym/

	$(dodir) $(PORTAGE_TARGET_DIR)/bin
	$(doexe) $(PORTAGE_DIR)/bin/* $(PORTAGE_DIR)/src/tbz2tool $(PORTAGE_TARGET_DIR)/bin/

	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(PORTAGE_DIR)/src/sandbox-1.1 install

	$(dodir) $(PORTAGE_TARGET_DIR)/usr/bin
	$(dodir) $(PORTAGE_TARGET_DIR)/usr/sbin
	$(dosym) newins $(PORTAGE_TARGET_DIR)/bin/donewins
	for sbin in pkgmerge ebuild ebuild.sh etc-update dispatch-conf \
		archive-conf fixpackages env-update regenworld emerge-webrsync ; do \
		$(dosym) ../lib/portage/bin/$${sbin} $(TARGET_DIR)/usr/sbin/$${sbin}; \
	done
	for bin in xpak repoman tbz2tool portageq g-cpan.pl quickpkg emerge ; do \
		$(dosym) ../lib/portage/bin/$${bin} $(TARGET_DIR)/usr/bin/$${bin}; \
	done

portage: python uclibc $(TARGET_DIR)/$(PORTAGE_TARGET_BINARY)

portage-clean:
	(cd $(TARGET_DIR)/etc; \
		rm -f make.globals make.conf etc-update.conf dispatch-conf.conf)
	rm -rf $(PORTAGE_TARGET_DIR)

	for sbin in pkgmerge ebuild ebuild.sh etc-update dispatch-conf \
		archive-conf fixpackages env-update regenworld emerge-webrsync ; do \
		rm -f $(TARGET_DIR)/usr/sbin/$${sbin}; \
	done
	for bin in xpak repoman tbz2tool portageq g-cpan.pl quickpkg emerge ; do \
		rm -f $(TARGET_DIR)/usr/bin/$${bin}; \
	done

portage-dirclean:
	rm -rf $(PORTAGE_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_PORTAGE)),y)
TARGETS+=portage
endif
