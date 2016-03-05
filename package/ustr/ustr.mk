################################################################################
#
# ustr
#
################################################################################

USTR_VERSION = 1.0.4
USTR_SOURCE = ustr-$(USTR_VERSION).tar.bz2
USTR_SITE = http://www.and.org/ustr/$(USTR_VERSION)
USTR_LICENSE = BSD-2c, MIT, LGPLv2+
USTR_LICENSE_FILES = LICENSE LICENSE_BSD LICENSE_LGPL LICENSE_MIT
USTR_AUTORECONF = YES
USTR_PATCH = \
	http://http.debian.net/debian/pool/main/u/ustr/ustr_$(USTR_VERSION)-5.debian.tar.xz

USTR_INSTALL_STAGING = YES

# ustr only builds the static library by default, but the default
# install rule will install both the static and the shared libraries,
# which means the shared one is build during the install step. :-(
#
# We can however instruct ustr to build both at build time, by adding
# 'all-shared' to the default 'all' rule.
USTR_MAKE_OPTS = all all-shared

$(eval $(autotools-package))
$(eval $(host-autotools-package))
