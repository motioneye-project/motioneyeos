################################################################################
#
# atftp
#
################################################################################

ATFTP_VERSION = 0.7.2
ATFTP_SITE = http://sourceforge.net/projects/atftp/files
ATFTP_LICENSE = GPL-2.0+
ATFTP_LICENSE_FILES = LICENSE
# 0001-Makefile.am-link-against-libpthread-for-atftp.patch patches Makefile.am
ATFTP_AUTORECONF = YES
ATFTP_CONF_OPTS = --disable-libwrap --disable-mtftp
# For static we need to explicitly link against libpthread
ATFTP_LIBS = -lpthread
# -fgnu89-inline is needed to avoid multiple definition error with gcc 5. See
# https://gcc.gnu.org/gcc-5/porting_to.html.
ATFTP_CONF_ENV = LIBS="$(ATFTP_LIBS)" \
	CFLAGS="$(TARGET_CFLAGS) -fgnu89-inline"

ifeq ($(BR2_PACKAGE_READLINE),y)
ATFTP_DEPENDENCIES += readline
ATFTP_CONF_OPTS += --enable-libreadline
# For static, readline links with ncurses
ATFTP_LIBS += -lncurses
else
ATFTP_CONF_OPTS += --disable-libreadline
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
ATFTP_DEPENDENCIES += pcre
ATFTP_CONF_OPTS += --enable-libpcre
else
ATFTP_CONF_OPTS += --disable-libpcre
endif

$(eval $(autotools-package))
