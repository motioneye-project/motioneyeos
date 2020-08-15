################################################################################
#
# python-backcall
#
################################################################################

PYTHON_BACKCALL_VERSION = 0.1.0
PYTHON_BACKCALL_SOURCE = backcall-$(PYTHON_BACKCALL_VERSION).tar.gz
PYTHON_BACKCALL_SITE = https://files.pythonhosted.org/packages/84/71/c8ca4f5bb1e08401b916c68003acf0a0655df935d74d93bf3f3364b310e0
PYTHON_BACKCALL_SETUP_TYPE = distutils
# From https://github.com/takluyver/backcall/blob/master/LICENSE
PYTHON_BACKCALL_LICENSE = BSD-3-Clause

$(eval $(python-package))
