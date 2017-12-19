################################################################################
#
# python-flup
#
################################################################################

PYTHON_FLUP_VERSION = 1.0.3.dev20161029
PYTHON_FLUP_SOURCE = flup-$(PYTHON_FLUP_VERSION).tar.gz
PYTHON_FLUP_SITE = https://pypi.python.org/packages/17/33/36768930a5ffe4f294ed3987c631bfd3fddb4f9e5e46bc8dc30fd731dbcd

PYTHON_FLUP_LICENSE = BSD-2-Clause, MIT

PYTHON_FLUP_SETUP_TYPE = setuptools

$(eval $(python-package))
