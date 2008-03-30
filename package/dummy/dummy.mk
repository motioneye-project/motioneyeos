#############################################################
#
# dummy
#
#############################################################

# Current version, use the latest unless there are any known issues.
DUMMY_VERSION=1.2.3
# The filename of the package to download.
DUMMY_SOURCE=dummy-$(DUMMY_VERSION).tar.bz2
# The site and path to where the source packages are.
DUMMY_SITE=http://www.example.net/dummy/source
# The directory which the source package is extracted to.
DUMMY_DIR=$(BUILD_DIR)/dummy-$(DUMMY_VERSION)
# Which decompression to use, BZCAT or ZCAT.
DUMMY_CAT:=$(BZCAT)
# Target binary for the package.
DUMMY_BINARY:=dummy
# Not really needed, but often handy define.
DUMMY_TARGET_BINARY:=usr/bin/$(DUMMY_BINARY)

# The download rule. Main purpose is to download the source package.
$(DL_DIR)/$(DUMMY_SOURCE):
	$(WGET) -P $(DL_DIR) $(DUMMY_SITE)/$(DUMMY_SOURCE)

# The unpacking rule. Main purpose is to extract the source package, apply any
# patches and update config.guess and config.sub.
$(DUMMY_DIR)/.unpacked: $(DL_DIR)/$(DUMMY_SOURCE)
	$(DUMMY_CAT) $(DL_DIR)/$(DUMMY_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DUMMY_DIR) package/dummy/ dummy-$(DUMMY_VERSION)-\*.patch\*
	$(CONFIG_UPDATE) $(DUMMY_DIR)
	touch $@

# The configure rule. Main purpose is to get the package ready for compilation,
# usually by running the configure script with different kinds of options
# specified.
$(DUMMY_DIR)/.configured: $(DUMMY_DIR)/.unpacked
	(cd $(DUMMY_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(DUMMY_DIR)/$(DUMMY_BINARY): $(DUMMY_DIR)/.configured
	$(MAKE) -C $(DUMMY_DIR)

# The installing rule. Main purpose is to install the binary into the target
# root directory and make sure it is stripped from debug symbols to reduce the
# space requirements to a minimum.
#
# Only the files needed to run the application should be installed to the
# target root directory, to not waste valuable flash space.
$(TARGET_DIR)/$(DUMMY_TARGET_BINARY): $(DUMMY_DIR)/$(DUMMY_BINARY)
	cp -dpf $(DUMMY_DIR)/dummy $@
	$(STRIP) --strip-unneeded $@

# Main rule which shows which other packages must be installed before the dummy
# package is installed. This to ensure that all depending libraries are
# installed.
dummy:	uclibc $(TARGET_DIR)/$(DUMMY_TARGET_BINARY)

# Source download rule. Main purpose to download the source package. Since some
# people would like to work offline, it is mandotory to implement a rule which
# downloads everything this package needs.
dummy-source: $(DL_DIR)/$(DUMMY_SOURCE)

# Clean rule. Main purpose is to clean the build directory, thus forcing a new
# rebuild the next time Buildroot is made.
dummy-clean:
	-$(MAKE) -C $(DUMMY_DIR) clean

# Directory clean rule. Main purpose is to remove the build directory, forcing
# a new extraction, patching and rebuild the next time Buildroot is made.
dummy-dirclean:
	rm -rf $(DUMMY_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
# This is how the dummy package is added to the list of rules to build.
ifeq ($(strip $(BR2_PACKAGE_DUMMY)),y)
TARGETS+=dummy
endif
