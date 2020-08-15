################################################################################
#
# python3-cheetah
#
################################################################################

# Please keep in sync with
# package/python-cheetah/python-cheetah.mk
PYTHON3_CHEETAH_VERSION = 3.2.4
PYTHON3_CHEETAH_SOURCE = Cheetah3-$(PYTHON3_CHEETAH_VERSION).tar.gz
PYTHON3_CHEETAH_SITE = https://files.pythonhosted.org/packages/4e/72/e6a7d92279e3551db1b68fd336fd7a6e3d2f2ec742bf486486e6150d77d2
PYTHON3_CHEETAH_LICENSE = MIT
PYTHON3_CHEETAH_LICENSE_FILES = LICENSE
PYTHON3_CHEETAH_SETUP_TYPE = setuptools
HOST_PYTHON3_CHEETAH_DL_SUBDIR = python-cheetah
HOST_PYTHON3_CHEETAH_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
