################################################################################
#
# atftp
#
################################################################################

ATFTP_VERSION  = 0.7.1
ATFTP_SITE = http://sourceforge.net/projects/atftp/files/
ATFTP_LICENSE = GPLv2+
ATFTP_LICENSE_FILES = LICENSE
ATFTP_CONF_OPT = --disable-libwrap --disable-mtftp

ifeq ($(BR2_PACKAGE_READLINE),y)
ATFTP_DEPENDENCIES += readline
ATFTP_CONF_OPT += --enable-libreadline
else
ATFTP_CONF_OPT += --disable-libreadline
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
ATFTP_DEPENDENCIES += pcre
ATFTP_CONF_OPT += --enable-libpcre
else
ATFTP_CONF_OPT += --disable-libpcre
endif

$(eval $(autotools-package))
