################################################################################
#
# gmock
#
################################################################################

# Make sure this remains the same version as the gtest one
GMOCK_VERSION = 1.7.0
GMOCK_SOURCE = gmock-$(GMOCK_VERSION).zip
GMOCK_SITE = http://googlemock.googlecode.com/files
GMOCK_INSTALL_STAGING = YES
GMOCK_INSTALL_TARGET = NO
GMOCK_LICENSE = BSD-3c
GMOCK_LICENSE_FILES = LICENSE
GMOCK_DEPENDENCIES = gtest host-gmock

# GMock 1.7.0 relies on Python 2.7 syntax which is NOT compatible with Python3.
HOST_GMOCK_DEPENDENCIES = host-python
HOST_GMOCK_PYTHONPATH=$(HOST_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages

# Static linking is required in order to keep the GMock package completely
# separated from GTest. According to GMock's README file:
#
#   "Google Mock can be used as a DLL, but the same DLL must contain Google
#    Test as well.  See Google Test's README file for instructions on how to
#    set up necessary compiler settings".
GMOCK_CONF_OPTS = --enable-static --disable-shared

define GMOCK_EXTRACT_CMDS
	$(UNZIP) $(DL_DIR)/$(GMOCK_SOURCE) -d $(BUILD_DIR)
endef

# We can't use the default rule for autotools-package staging because it fails
# because it tries to rebuild/install gtest stuff and fails after this error:
#    "'make install' is dangerous and not supported. Instead, see README for
#      how to integrate Google Test into your build system."
define GMOCK_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/lib/.libs/libgmock.a $(STAGING_DIR)/usr/lib/libgmock.a
	$(INSTALL) -D -m 0755 $(@D)/lib/.libs/libgmock_main.a $(STAGING_DIR)/usr/lib/libgmock_main.a
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/include/gmock/
	cp -rp $(@D)/include/gmock/* $(STAGING_DIR)/usr/include/gmock/
	$(INSTALL) -D -m 0755 package/gmock/gmock.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/gmock.pc
endef

# Unzipping inside $(@D) and moving everything from the created subdirectory is
# required because unzipping directly in $(BUILD_DIR) would cause host-gmock to
# overwrite the gmock subdir instead of unzipping in a host-gmock subdir.
define HOST_GMOCK_EXTRACT_CMDS
	$(UNZIP) $(DL_DIR)/$(GMOCK_SOURCE) -d $(@D)
	mv $(@D)/gmock-$(GMOCK_VERSION)/* $(@D)
	rmdir $(@D)/gmock-$(GMOCK_VERSION)
endef

define HOST_GMOCK_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/scripts/generator/gmock_gen.py $(HOST_DIR)/usr/bin/gmock_gen.py
	ln -sf gmock_gen.py $(HOST_DIR)/usr/bin/gmock_gen
	cp -rp $(@D)/scripts/generator/cpp $(HOST_GMOCK_PYTHONPATH)
endef

$(eval $(autotools-package))
# The host package does not build anything, just installs gmock_gen stuff, so
# it does not need to be a host-autotools-package.
$(eval $(host-generic-package))
