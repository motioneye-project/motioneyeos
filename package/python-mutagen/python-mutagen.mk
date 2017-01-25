################################################################################
#
# python-mutagen
#
################################################################################

PYTHON_MUTAGEN_VERSION = 1.36
PYTHON_MUTAGEN_SOURCE = mutagen-$(PYTHON_MUTAGEN_VERSION).tar.gz
PYTHON_MUTAGEN_SITE = https://pypi.python.org/packages/69/14/4a5c8360a727563291a7159de935ffff2b99ee783928169f0fea7445370f
PYTHON_MUTAGEN_LICENSE = GPLv2
PYTHON_MUTAGEN_LICENSE_FILES = COPYING
PYTHON_MUTAGEN_SETUP_TYPE = distutils

$(eval $(python-package))
