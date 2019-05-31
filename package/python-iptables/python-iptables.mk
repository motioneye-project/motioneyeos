################################################################################
#
# python-iptables
#
################################################################################

PYTHON_IPTABLES_VERSION = 0.13.0
PYTHON_IPTABLES_SITE = https://files.pythonhosted.org/packages/6e/3a/866f5b1bccc6a4d94811f84304d700da14518ff55b80e08ff2241b3221bf
PYTHON_IPTABLES_SETUP_TYPE = setuptools
PYTHON_IPTABLES_LICENSE = Apache-2.0
PYTHON_IPTABLES_LICENSE_FILES = NOTICE

$(eval $(python-package))
