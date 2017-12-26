################################################################################
#
# libpqxx
#
################################################################################

LIBPQXX_VERSION = 4.0.1
LIBPQXX_SITE = http://pqxx.org/download/software/libpqxx
LIBPQXX_INSTALL_STAGING = YES
LIBPQXX_DEPENDENCIES = postgresql
LIBPQXX_LICENSE = BSD-3-Clause
LIBPQXX_LICENSE_FILES = COPYING

# 0001-Fix-broken-sed-call-in-configure.ac.in.patch
LIBPQXX_AUTORECONF = YES

LIBPQXX_CONF_ENV += ac_cv_path_PG_CONFIG=$(STAGING_DIR)/usr/bin/pg_config

$(eval $(autotools-package))
