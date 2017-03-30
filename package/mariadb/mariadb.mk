################################################################################
#
# mariadb
#
################################################################################

MARIADB_VERSION = 10.1.22
MARIADB_SITE = https://downloads.mariadb.org/interstitial/mariadb-$(MARIADB_VERSION)/source
MARIADB_LICENSE = GPL-2.0 (server), GPL-2.0 with FLOSS exception (GPL client library), LGPL-2.0 (LGPL client library)
MARIADB_LICENSE_FILES = README COPYING COPYING.LESSER
MARIADB_INSTALL_STAGING = YES
MARIADB_PROVIDES = mysql

MARIADB_DEPENDENCIES = \
	host-mariadb \
	ncurses \
	openssl \
	zlib \
	libaio \
	libxml2 \
	readline

# We won't need unit tests
MARIADB_CONF_OPTS += -DWITH_UNIT_TESTS=0

# Mroonga needs libstemmer. Some work still needs to be done before it can be
# included in buildroot. Disable it for now.
MARIADB_CONF_OPTS += -DWITHOUT_MROONGA=1

# This value is determined automatically during straight compile by compiling
# and running a test code. You cannot do that during cross-compile. However the
# stack grows downward in most if not all modern systems. The only exception I
# am aware of is PA-RISC which is not supported by buildroot. Therefore it makes
# sense to hardcode the value. If an arch is added the stack of which grows up
# one should expect unpredictable behavior at run time.
MARIADB_CONF_OPTS += -DSTACK_DIRECTION=-1

# Jemalloc was added for TokuDB. Since its configure script seems somewhat broken
# when it comes to cross-compilation we shall disable it and also disable TokuDB.
MARIADB_CONF_OPTS += -DWITH_JEMALLOC=no -DWITHOUT_TOKUDB=1

# Make it explicit that we are cross-compiling
MARIADB_CONF_OPTS += -DCMAKE_CROSSCOMPILING=1

# Explicitly disable dtrace to avoid detection of a host version
MARIADB_CONF_OPTS += -DENABLE_DTRACE=0

ifeq ($(BR2_PACKAGE_MARIADB_SERVER),y)
MARIADB_CONF_OPTS += -DWITH_EMBEDDED_SERVER=ON
else
MARIADB_CONF_OPTS += -DWITHOUT_SERVER=ON
endif

MARIADB_CONF_OPTS += \
	-DINSTALL_DOCDIR=share/doc/mariadb-$(MARIADB_VERSION) \
	-DINSTALL_DOCREADMEDIR=share/doc/mariadb-$(MARIADB_VERSION) \
	-DINSTALL_MANDIR=share/man \
	-DINSTALL_MYSQLSHAREDIR=share/mysql \
	-DINSTALL_MYSQLTESTDIR=share/mysql/test \
	-DINSTALL_PLUGINDIR=lib/mysql/plugin \
	-DINSTALL_SBINDIR=sbin \
	-DINSTALL_SCRIPTDIR=bin \
	-DINSTALL_SQLBENCHDIR=share/mysql/bench \
	-DINSTALL_SUPPORTFILESDIR=share/mysql \
	-DMYSQL_DATADIR=/var/lib/mysql \
	-DMYSQL_UNIX_ADDR=$(MYSQL_SOCKET)

# Some helpers must be compiled for host in order to crosscompile mariadb for
# the target. They are then included by import_executables.cmake which is
# generated during the build of the host helpers. It is not necessary to build
# the whole host package, only the "import_executables" target.
# -DIMPORT_EXECUTABLES=$(HOST_MARIADB_BUILDDIR)/import_executables.cmake
# must then be passed to cmake during target build.
# see also https://mariadb.com/kb/en/mariadb/cross-compiling-mariadb/
HOST_MARIADB_MAKE_OPTS = import_executables

MARIADB_CONF_OPTS += \
	-DIMPORT_EXECUTABLES=$(HOST_MARIADB_BUILDDIR)/import_executables.cmake

# Don't install host-mariadb. We just need to build import_executable
# Therefore only run 'true' and do nothing, not even the default action.
HOST_MARIADB_INSTALL_CMDS = true

ifeq ($(BR2_PACKAGE_MARIADB_SERVER),y)
define MARIADB_USERS
	mysql -1 mysql -1 * /var/lib/mysql - - MySQL Server
endef

define MARIADB_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/mariadb/S97mysqld \
		$(TARGET_DIR)/etc/init.d/S97mysqld
endef

define MARIADB_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/mariadb/mysqld.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mysqld.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/mysqld.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/mysqld.service
endef
endif

define MARIADB_POST_INSTALL
	mkdir -p $(TARGET_DIR)/var/lib/mysql
	$(INSTALL) -D -m 644 $(TARGET_DIR)/usr/share/mysql/my-small.cnf \
		$(TARGET_DIR)/etc/mysql/my.cnf
	# We don't need this on the target as it's only useful in staging
	$(RM) $(TARGET_DIR)/usr/bin/mysql_config
	# Remove test suite
	$(RM) -r $(TARGET_DIR)/usr/share/mysql/test
endef

MARIADB_POST_INSTALL_TARGET_HOOKS += MARIADB_POST_INSTALL

$(eval $(cmake-package))
$(eval $(host-cmake-package))
