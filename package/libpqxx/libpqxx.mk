################################################################################
#
# libpqxx
#
################################################################################

LIBPQXX_VERSION = 6.2.5
LIBPQXX_SITE = $(call github,jtv,libpqxx,$(LIBPQXX_VERSION))
LIBPQXX_INSTALL_STAGING = YES
LIBPQXX_DEPENDENCIES = postgresql
LIBPQXX_LICENSE = BSD-3-Clause
LIBPQXX_LICENSE_FILES = COPYING

LIBPQXX_CONF_ENV += ac_cv_path_PG_CONFIG=$(STAGING_DIR)/usr/bin/pg_config

$(eval $(autotools-package))
