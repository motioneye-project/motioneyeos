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
PYTHON_PYPARSING_SETUP_TYPE      = distutils

$(eval $(python-package))
