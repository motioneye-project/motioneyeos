#############################################################
#
# python
#
#############################################################
PYTHON_VERSION=2.4.2
PYTHON_VERSION_SHORT=2.4
PYTHON_SOURCE:=Python-$(PYTHON_VERSION).tar.bz2
PYTHON_SITE:=http://python.org/ftp/python/$(PYTHON_VERSION)
PYTHON_DIR:=$(BUILD_DIR)/Python-$(PYTHON_VERSION)
PYTHON_CAT:=$(BZCAT)
PYTHON_BINARY:=python
PYTHON_TARGET_BINARY:=usr/bin/python
PYTHON_DEPS:=

BR2_PYTHON_DISABLED_MODULES=dbm zipfile

ifeq ($(BR2_PACKAGE_PYTHON_READLINE),y)
PYTHON_DEPS += readline-target
else
BR2_PYTHON_DISABLED_MODULES += readline
endif

ifeq ($(BR2_PACKAGE_PYTHON_CURSES),y)
PYTHON_DEPS += ncurses
else
BR2_PYTHON_DISABLED_MODULES += _curses _curses_panel
endif

ifeq ($(BR2_PACKAGE_PYTHON_PYEXPAT),y)
PYTHON_DEPS += expat
else
BR2_PYTHON_DISABLED_MODULES += pyexpat
endif

ifeq ($(BR2_PACKAGE_PYTHON_GDBM),y)
PYTHON_DEPS += gdbm
else
BR2_PYTHON_DISABLED_MODULES += gdbm
endif

ifeq ($(BR2_PACKAGE_PYTHON_BSDDB),y)
PYTHON_DEPS += berkeleydb
else
BR2_PYTHON_DISABLED_MODULES += bsddb
endif

ifeq ($(BR2_PACKAGE_PYTHON_TKINTER),y)
PYTHON_DEPS += tcl
else
BR2_PYTHON_DISABLED_MODULES += _tkinter
endif

ifeq ($(BR2_PACKAGE_PYTHON_SSL),y)
PYTHON_DEPS += openssl
endif

ifneq ($(BR2_PACKAGE_PYTHON_NIS),y)
BR2_PYTHON_DISABLED_MODULES += nis
endif

ifneq ($(BR2_PACKAGE_PYTHON_CODECSCJK),y)
BR2_PYTHON_DISABLED_MODULES += _codecs_kr _codecs_jp _codecs_cn _codecs_tw _codecs_hk
endif

ifneq ($(BR2_PACKAGE_PYTHON_UNICODEDATA),y)
BR2_PYTHON_DISABLED_MODULES += unicodedata
endif

$(DL_DIR)/$(PYTHON_SOURCE):
	 $(WGET) -P $(DL_DIR) $(PYTHON_SITE)/$(PYTHON_SOURCE)

python-source: $(DL_DIR)/$(PYTHON_SOURCE)

$(PYTHON_DIR)/.unpacked: $(DL_DIR)/$(PYTHON_SOURCE)
	$(PYTHON_CAT) $(DL_DIR)/$(PYTHON_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(PYTHON_DIR)/.patched: $(PYTHON_DIR)/.unpacked
	toolchain/patch-kernel.sh $(PYTHON_DIR) package/python/ python\*.patch
	touch $@

$(PYTHON_DIR)/.hostpython: $(PYTHON_DIR)/.patched
	(cd $(PYTHON_DIR); rm -rf config.cache; \
		CC="$(HOSTCC)" OPT="-O2" \
		./configure \
		--with-cxx=no \
		$(DISABLE_NLS) && \
		$(MAKE) python Parser/pgen && \
		mv python hostpython && \
		mv Parser/pgen Parser/hostpgen && \
		$(MAKE) distclean \
	) && \
	touch $@

$(PYTHON_DIR)/.configured: $(PYTHON_DIR)/.hostpython
	(cd $(PYTHON_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		OPT="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--with-cxx=no \
		$(DISABLE_IPV6) \
		$(DISABLE_NLS) \
	)
	touch $@

$(PYTHON_DIR)/$(PYTHON_BINARY): $(PYTHON_DIR)/.configured
ifneq ($(BR2_PACKAGE_PYTHON_SSL),y)
	export PYTHON_DISABLE_SSL=1
endif
	$(MAKE) CC=$(TARGET_CC) -C $(PYTHON_DIR) DESTDIR=$(TARGET_DIR) \
		PYTHON_MODULES_INCLUDE=$(STAGING_DIR)/usr/include \
		PYTHON_MODULES_LIB=$(STAGING_DIR)/lib \
		PYTHON_DISABLE_MODULES="$(BR2_PYTHON_DISABLED_MODULES)" \
		HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen

$(TARGET_DIR)/$(PYTHON_TARGET_BINARY): $(PYTHON_DIR)/$(PYTHON_BINARY)
ifneq ($(BR2_PACKAGE_PYTHON_SSL),y)
	export PYTHON_DISABLE_SSL=1
endif
	LD_LIBRARY_PATH=$(STAGING_DIR)/lib
	$(MAKE) CC=$(TARGET_CC) -C $(PYTHON_DIR) install \
		DESTDIR=$(TARGET_DIR) CROSS_COMPILE=yes \
		PYTHON_MODULES_INCLUDE=$(STAGING_DIR)/usr/include \
		PYTHON_MODULES_LIB=$(STAGING_DIR)/lib \
		PYTHON_DISABLE_MODULES="$(BR2_PYTHON_DISABLED_MODULES)" \
		HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen && \
	rm $(TARGET_DIR)/usr/bin/python?.? && \
	rm $(TARGET_DIR)/usr/bin/idle && \
	rm $(TARGET_DIR)/usr/bin/pydoc && \
	find $(TARGET_DIR)/usr/lib/ -name '*.pyo' -exec rm {} \; && \
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc \
		$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_SHORT)/test
	cp -dpr $(TARGET_DIR)/usr/include/python$(PYTHON_VERSION_SHORT) $(STAGING_DIR)/usr/include/
	mkdir -p $(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_SHORT)
	cp -dpr $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_SHORT)/config $(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_SHORT)/

ifeq ($(BR2_PACKAGE_PYTHON_PY_ONLY),y)
	find $(TARGET_DIR)/usr/lib/ -name '*.pyc' -exec rm {} \;
endif
ifeq ($(BR2_PACKAGE_PYTHON_PYC_ONLY),y)
	find $(TARGET_DIR)/usr/lib/ -name '*.py' -exec rm {} \;
endif
ifneq ($(BR2_PACKAGE_PYTHON_DEV),y)
	rm -rf $(TARGET_DIR)/usr/include/python$(PYTHON_VERSION_SHORT)
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_SHORT)/config
	find $(TARGET_DIR)/usr/lib/ -name '*.py' -exec rm {} \;
endif
ifneq ($(BR2_PACKAGE_PYTHON_BSDDB),y)
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_SHORT)/bsddb
endif
ifneq ($(BR2_PACKAGE_PYTHON_CURSES),y)
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_SHORT)/curses
endif
ifneq ($(BR2_PACKAGE_PYTHON_TKINTER),y)
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_SHORT)/lib-tk
endif

python: uclibc $(PYTHON_DEPS) $(TARGET_DIR)/$(PYTHON_TARGET_BINARY)

python-clean:
	-$(MAKE) -C $(PYTHON_DIR) distclean
	rm $(PYTHON_DIR)/.configured $(TARGET_DIR)/$(PYTHON_TARGET_BINARY)

python-dirclean:
	rm -rf $(PYTHON_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_PYTHON)),y)
TARGETS+=python
endif
