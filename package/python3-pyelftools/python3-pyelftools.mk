################################################################################
#
# python3-pyelftools
#
################################################################################

# Please keep in sync with package/python-pyelftools/python-pyelftools.mk
PYTHON3_PYELFTOOLS_VERSION = 0.25
PYTHON3_PYELFTOOLS_SOURCE = pyelftools-$(PYTHON_PYELFTOOLS_VERSION).tar.gz
PYTHON3_PYELFTOOLS_SITE = https://files.pythonhosted.org/packages/fa/9a/0674cb1725196568bdbca98304f2efb17368b57af1a4bb3fc772c026f474
PYTHON3_PYELFTOOLS_LICENSE = Public domain
PYTHON3_PYELFTOOLS_LICENSE_FILES = LICENSE
PYTHON3_PYELFTOOLS_SETUP_TYPE = setuptools
HOST_PYTHON3_PYELFTOOLS_DL_SUBDIR = python-pyelftools
HOST_PYTHON3_PYELFTOOLS_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
