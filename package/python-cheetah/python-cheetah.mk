################################################################################
#
# python-cheetah
#
################################################################################

# Please keep in sync with package/python3-cheetah/python3-cheetah.mk
PYTHON_CHEETAH_VERSION = 3.2.4
PYTHON_CHEETAH_SOURCE = Cheetah3-$(PYTHON_CHEETAH_VERSION).tar.gz
PYTHON_CHEETAH_SITE = https://files.pythonhosted.org/packages/4e/72/e6a7d92279e3551db1b68fd336fd7a6e3d2f2ec742bf486486e6150d77d2
PYTHON_CHEETAH_LICENSE = MIT
PYTHON_CHEETAH_LICENSE_FILES = LICENSE
PYTHON_CHEETAH_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
