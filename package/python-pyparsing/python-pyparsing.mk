################################################################################
#
# python-pyparsing
#
################################################################################

PYTHON_PYPARSING_VERSION         = 1.5.6
PYTHON_PYPARSING_SOURCE          = pyparsing-$(PYTHON_PYPARSING_VERSION).tar.gz
PYTHON_PYPARSING_SITE            = http://downloads.sourceforge.net/project/pyparsing/pyparsing/pyparsing-$(PYTHON_PYPARSING_VERSION)
PYTHON_PYPARSING_LICENSE         = MIT
PYTHON_PYPARSING_LICENSE_FILES   = LICENSE
PYTHON_PYPARSING_INSTALL_STAGING = YES
PYTHON_PYPARSING_DEPENDENCIES    = python

# Shamelessly vampirised from python-pygame ;-)
define PYTHON_PYPARSING_BUILD_CMDS
	(cd $(@D);                                              \
	 CC="$(TARGET_CC)"                                      \
	 CFLAGS="$(TARGET_CFLAGS)"                              \
	 LDSHARED="$(TARGET_CROSS)gcc -shared"                  \
	 CROSS_COMPILING=yes                                    \
	 _python_sysroot=$(STAGING_DIR)                         \
	 _python_srcdir=$(BUILD_DIR)/python$(PYTHON_VERSION)    \
	 _python_prefix=/usr                                    \
	 _python_exec_prefix=/usr                               \
	 $(HOST_DIR)/usr/bin/python setup.py build              \
	)
endef

# Shamelessly vampirised from python-pygame ;-)
define PYTHON_PYPARSING_INSTALL_TARGET_CMDS
	(cd $(@D);                                              \
	 $(HOST_DIR)/usr/bin/python setup.py install            \
	                            --prefix=$(TARGET_DIR)/usr  \
	)
endef

$(eval $(generic-package))
