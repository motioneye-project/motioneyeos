#############################################################
#
# build binutils for use on the host system
#
#############################################################
BINUTILS_SITE:=http://ftp.kernel.org/pub/linux/devel/binutils
BINUTILS_SOURCE:=binutils-2.14.90.0.6.tar.bz2
BINUTILS_DIR:=$(TOOL_BUILD_DIR)/binutils-2.14.90.0.6
BINUTILS_CAT:=bzcat

BINUTILS_DIR1:=$(TOOL_BUILD_DIR)/binutils-build
$(DL_DIR)/$(BINUTILS_SOURCE):
	$(WGET) -P $(DL_DIR) $(BINUTILS_SITE)/$(BINUTILS_SOURCE)

$(BINUTILS_DIR)/.unpacked: $(DL_DIR)/$(BINUTILS_SOURCE)
	mkdir -p $(TOOL_BUILD_DIR)
	mkdir -p $(DL_DIR)
	mkdir -p $(STAGING_DIR)
	mkdir -p $(STAGING_DIR)/include
	mkdir -p $(STAGING_DIR)/lib/gcc-lib
	mkdir -p $(STAGING_DIR)/usr/lib
	mkdir -p $(STAGING_DIR)/usr/bin;
	mkdir -p $(STAGING_DIR)/$(GNU_TARGET_NAME)/
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../lib)
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../include)
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../include sys-include)
	(cd $(STAGING_DIR)/usr/lib; ln -fs ../../lib/gcc-lib)
	$(BINUTILS_CAT) $(DL_DIR)/$(BINUTILS_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	touch $(BINUTILS_DIR)/.unpacked

$(BINUTILS_DIR)/.patched: $(BINUTILS_DIR)/.unpacked
	# Apply any files named binutils-*.patch from the source directory to binutils
	$(SOURCE_DIR)/patch-kernel.sh $(BINUTILS_DIR) $(SOURCE_DIR) binutils-*.patch
	touch $(BINUTILS_DIR)/.patched

$(BINUTILS_DIR1)/.configured: $(BINUTILS_DIR)/.patched
	mkdir -p $(BINUTILS_DIR1)
	(cd $(BINUTILS_DIR1); CC=$(HOSTCC) \
		CC_FOR_HOST=$(HOSTCC) \
		CXX_FOR_HOST=$(HOSTCC) \
		$(BINUTILS_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_HOST_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(STAGING_DIR) \
		--exec-prefix=$(STAGING_DIR) \
		--bindir=$(STAGING_DIR)/bin \
		--sbindir=$(STAGING_DIR)/sbin \
		--sysconfdir=$(STAGING_DIR)/etc \
		--datadir=$(STAGING_DIR)/share \
		--includedir=$(STAGING_DIR)/include \
		--libdir=$(STAGING_DIR)/lib \
		--localstatedir=$(STAGING_DIR)/var \
		--mandir=$(STAGING_DIR)/man \
		--infodir=$(STAGING_DIR)/info \
		--enable-targets=$(GNU_TARGET_NAME) \
		--with-sysroot=$(STAGING_DIR) \
		--with-lib-path="$(STAGING_DIR)/usr/lib:$(STAGING_DIR)/lib" \
		$(MULTILIB) \
		--program-prefix=$(ARCH)-uclibc-);
	touch $(BINUTILS_DIR1)/.configured

$(BINUTILS_DIR1)/binutils/objdump: $(BINUTILS_DIR1)/.configured
	$(MAKE) $(JLEVEL) CC_FOR_HOST=$(HOSTCC) CXX_FOR_HOST=$(HOSTCC) \
		-C $(BINUTILS_DIR1);

$(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ld: $(BINUTILS_DIR1)/binutils/objdump 
	$(MAKE) $(JLEVEL) CC_FOR_HOST=$(HOSTCC) CXX_FOR_HOST=$(HOSTCC) \
		-C $(BINUTILS_DIR1) install;
	rm -rf $(STAGING_DIR)/info $(STAGING_DIR)/man $(STAGING_DIR)/share/doc \
		$(STAGING_DIR)/share/locale
	mkdir -p $(STAGING_DIR)/usr/bin;
	set -e; \
	for app in addr2line ar as c++filt gprof ld nm objcopy \
		    objdump ranlib readelf size strings strip ; \
	do \
		if [ -x $(STAGING_DIR)/bin/$(ARCH)-uclibc-$${app} ] ; then \
		    (cd $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin; \
			ln -fs ../../bin/$(ARCH)-uclibc-$${app} $${app}; \
		    ); \
		    (cd $(STAGING_DIR)/usr/bin; \
			ln -fs ../../bin/$(ARCH)-uclibc-$${app} $${app}; \
		    ); \
		fi; \
	done;

$(STAGING_DIR)/lib/libg.a:
	mkdir -p $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin
	mkdir -p $(STAGING_DIR)/usr/include/
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ar rv $(STAGING_DIR)/lib/libg.a;
	cp $(BINUTILS_DIR)/include/ansidecl.h $(STAGING_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/bfdlink.h $(STAGING_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/dis-asm.h $(STAGING_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/libiberty.h $(STAGING_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/symcat.h $(STAGING_DIR)/usr/include/
	cp $(BINUTILS_DIR1)/bfd/bfd.h $(STAGING_DIR)/usr/include/
	cp -a $(BINUTILS_DIR1)/bfd/.libs/* $(STAGING_DIR)/usr/lib/
	cp -a $(BINUTILS_DIR1)/opcodes/.libs/* $(STAGING_DIR)/usr/lib/
	cp -a $(BINUTILS_DIR1)/libiberty/libiberty.a $(STAGING_DIR)/usr/lib/

binutils: $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ld $(STAGING_DIR)/lib/libg.a

binutils-clean:
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)*
	-$(MAKE) -C $(BINUTILS_DIR1) clean

binutils-dirclean:
	rm -rf $(BINUTILS_DIR1)



#############################################################
#
# build binutils for use on the target system
#
#############################################################
BINUTILS_DIR2:=$(BUILD_DIR)/binutils-target
$(BINUTILS_DIR2)/.configured: $(BINUTILS_DIR)/.patched
	mkdir -p $(BINUTILS_DIR2)
	mkdir -p $(TARGET_DIR)/usr/include
	mkdir -p $(TARGET_DIR)/usr/$(GNU_TARGET_NAME)/
	(cd $(BINUTILS_DIR2); \
		$(TARGET_CONFIGURE_OPTS) \
		CC_FOR_BUILD=$(HOSTCC) \
		CXX_FOR_BUILD=$(HOSTCC) \
		AR_FOR_TARGET=$(TARGET_CROSS)ar \
		AS_FOR_TARGET=$(TARGET_CROSS)as \
		LD_FOR_TARGET=$(TARGET_CROSS)ld \
		NM_FOR_TARGET=$(TARGET_CROSS)nm \
		CC_FOR_TARGET=$(TARGET_CROSS)gcc \
		GCC_FOR_TARGET=$(TARGET_CROSS)gcc \
		CXX_FOR_TARGET=$(TARGET_CROSS)g++ \
		RANLIB_FOR_TARGET=$(TARGET_CROSS)ranlib \
		$(BINUTILS_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(ARCH)-linux \
		--prefix=/usr \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(MULTILIB) \
	);
	touch $(BINUTILS_DIR2)/.configured

$(BINUTILS_DIR2)/binutils/objdump: $(BINUTILS_DIR2)/.configured
	$(MAKE) $(JLEVEL) -C $(BINUTILS_DIR2) \
		CC_FOR_BUILD=$(HOSTCC) \
		CXX_FOR_BUILD=$(HOSTCC) \
		AR_FOR_TARGET=$(TARGET_CROSS)ar \
		AS_FOR_TARGET=$(TARGET_CROSS)as \
		LD_FOR_TARGET=$(TARGET_CROSS)ld \
		NM_FOR_TARGET=$(TARGET_CROSS)nm \
		CC_FOR_TARGET=$(TARGET_CROSS)gcc \
		GCC_FOR_TARGET=$(TARGET_CROSS)gcc \
		CXX_FOR_TARGET=$(TARGET_CROSS)g++ \
		RANLIB_FOR_TARGET=$(TARGET_CROSS)ranlib
	touch -c $(BINUTILS_DIR2)/binutils/objdump

$(TARGET_DIR)/usr/bin/ld: $(BINUTILS_DIR2)/binutils/objdump 
	$(MAKE) $(JLEVEL) -C $(BINUTILS_DIR2) \
		CC_FOR_BUILD=$(HOSTCC) \
		CXX_FOR_BUILD=$(HOSTCC) \
		AR_FOR_TARGET=$(TARGET_CROSS)ar \
		AS_FOR_TARGET=$(TARGET_CROSS)as \
		LD_FOR_TARGET=$(TARGET_CROSS)ld \
		NM_FOR_TARGET=$(TARGET_CROSS)nm \
		CC_FOR_TARGET=$(TARGET_CROSS)gcc \
		GCC_FOR_TARGET=$(TARGET_CROSS)gcc \
		CXX_FOR_TARGET=$(TARGET_CROSS)g++ \
		RANLIB_FOR_TARGET=$(TARGET_CROSS)ranlib \
		prefix=/usr \
		infodir=/usr/info \
		mandir=/usr/man \
		DESTDIR=$(TARGET_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	-$(STRIP) $(TARGET_DIR)/usr/$(GNU_TARGET_NAME)/bin/* > /dev/null 2>&1
	-$(STRIP) $(TARGET_DIR)/usr/bin/* > /dev/null 2>&1 

$(TARGET_DIR)/usr/lib/libg.a:
	$(TARGET_CROSS)ar rv $(TARGET_DIR)/usr/lib/libg.a;
	cp $(BINUTILS_DIR)/include/ansidecl.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/bfdlink.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/dis-asm.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/libiberty.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/symcat.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR2)/bfd/bfd.h $(TARGET_DIR)/usr/include/
	cp -a $(BINUTILS_DIR2)/bfd/.libs/* $(TARGET_DIR)/usr/lib/
	cp -a $(BINUTILS_DIR2)/opcodes/.libs/* $(TARGET_DIR)/usr/lib/
	cp -a $(BINUTILS_DIR2)/libiberty/libiberty.a $(TARGET_DIR)/usr/lib/

binutils_target: $(GCC_DEPENDANCY) $(TARGET_DIR)/usr/bin/ld $(TARGET_DIR)/usr/lib/libg.a

binutils_target-clean:
	rm -f $(TARGET_DIR)/bin/$(GNU_TARGET_NAME)*
	-$(MAKE) -C $(BINUTILS_DIR2) clean

binutils_target-dirclean:
	rm -rf $(BINUTILS_DIR2)





