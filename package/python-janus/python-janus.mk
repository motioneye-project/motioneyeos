################################################################################
#
# python-janus
#
################################################################################

PYTHON_JANUS_VERSION = 0.4.0
PYTHON_JANUS_SOURCE = janus-$(PYTHON_JANUS_VERSION).tar.gz
PYTHON_JANUS_SITE = https://files.pythonhosted.org/packages/e2/39/41fd545b99eac81d47fe346b8c78c09a3b187ce2fd9f3c9656dfe035e39a
PYTHON_JANUS_SETUP_TYPE = setuptools
PYTHON_JANUS_LICENSE = Apache-2.0
PYTHON_JANUS_LICENSE_FILES = LICENSE

$(eval $(python-package))
