################################################################################
#
# python-iptables
#
################################################################################

PYTHON_IPTABLES_VERSION = 0.14.0
PYTHON_IPTABLES_SITE = https://files.pythonhosted.org/packages/08/5e/16a5ca35c420b8059eeb72716e316eeb6f0e59ce028998d36b2dc87554e5
PYTHON_IPTABLES_SETUP_TYPE = setuptools
PYTHON_IPTABLES_LICENSE = Apache-2.0
PYTHON_IPTABLES_LICENSE_FILES = NOTICE

$(eval $(python-package))
