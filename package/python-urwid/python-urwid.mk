################################################################################
#
# python-urwid
#
################################################################################

PYTHON_URWID_VERSION = 1.2.1
PYTHON_URWID_SOURCE = urwid-$(PYTHON_URWID_VERSION).tar.gz
PYTHON_URWID_SITE = https://pypi.python.org/packages/source/u/urwid
PYTHON_URWID_LICENSE = LGPLv2.1+
PYTHON_URWID_LICENSE_FILES = COPYING
PYTHON_URWID_SETUP_TYPE = setuptools

$(eval $(python-package))
