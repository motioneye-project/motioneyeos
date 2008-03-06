#############################################################
#
# ncurses
# 
#############################################################
NCURSES_VERSION = 5.6
NCURSES_SITE = http://ftp.gnu.org/pub/gnu/ncurses
NCURSES_SOURCE = ncurses-$(NCURSES_VERSION).tar.gz
NCURSES_AUTORECONF = NO
NCURSES_INSTALL_STAGING = YES
NCURSES_INSTALL_TARGET = YES

ifneq ($(strip $(BR2_PACKAGE_NCURSES_TARGET_HEADERS)),y)
NCURSES_WANT_STATIC = --disable-static
endif

NCURSES_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(REAL_GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr \
		--exec-prefix=/usr --bindir=/usr/bin \
		--sbindir=/usr/sbin --libdir=/usr/lib \
		--libexecdir=/usr/lib --sysconfdir=/etc \
		--datadir=/usr/share --localstatedir=/var \
		--includedir=/usr/include --mandir=/usr/man \
		--infodir=/usr/info --with-terminfo-dirs=/usr/share/terminfo \
		--with-default-terminfo-dir=/usr/share/terminfo \
		--with-shared --without-cxx --without-cxx-binding \
		--without-ada --without-progs --disable-big-core \
		$(DISABLE_NLS) $(DISABLE_LARGEFILE) \
		--without-profile --without-debug --disable-rpath \
		--enable-echo --enable-const --enable-overwrite \
		--enable-broken_linker \
		$(NCURSES_WANT_STATIC) 

NCURSES_MAKE_OPT = libs panel menu form headers

NCURSES_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

NCURSES_DEPENDENCIES = uclibc 

$(eval $(call AUTOTARGETS,package,ncurses))