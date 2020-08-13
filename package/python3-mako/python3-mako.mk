################################################################################
#
# python3-mako
#
################################################################################

# Please keep in sync with
# package/python-mako/python-mako.mk
PYTHON3_MAKO_VERSION = 1.1.2
PYTHON3_MAKO_SOURCE = Mako-$(PYTHON_MAKO_VERSION).tar.gz
PYTHON3_MAKO_SITE = https://files.pythonhosted.org/packages/42/64/fc7c506d14d8b6ed363e7798ffec2dfe4ba21e14dda4cfab99f4430cba3a
PYTHON3_MAKO_SETUP_TYPE = setuptools
PYTHON3_MAKO_LICENSE = MIT
PYTHON3_MAKO_LICENSE_FILES = LICENSE
HOST_PYTHON3_MAKO_DL_SUBDIR = python-mako
HOST_PYTHON3_MAKO_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
