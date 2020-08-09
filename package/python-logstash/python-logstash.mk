################################################################################
#
# python-logstash
#
################################################################################

PYTHON_LOGSTASH_VERSION = 0.4.6
PYTHON_LOGSTASH_SITE = https://files.pythonhosted.org/packages/4e/8d/7ff2e8e8e2613e7bb7654790480bb4cf51a55721371adbb631b16cb16dce
PYTHON_LOGSTASH_SETUP_TYPE = distutils
PYTHON_LOGSTASH_LICENSE = MIT
PYTHON_LOGSTASH_LICENSE_FILES = LICENSE

$(eval $(python-package))
