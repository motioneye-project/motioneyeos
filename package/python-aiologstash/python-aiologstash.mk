################################################################################
#
# python-aiologstash
#
################################################################################

PYTHON_AIOLOGSTASH_VERSION = 2.0.0
PYTHON_AIOLOGSTASH_SOURCE = aiologstash-$(PYTHON_AIOLOGSTASH_VERSION).tar.gz
PYTHON_AIOLOGSTASH_SITE = https://files.pythonhosted.org/packages/1c/dc/382861d5d25ccc976d02118922598fc4547f74f3287793e270ed614d8176
PYTHON_AIOLOGSTASH_SETUP_TYPE = distutils
PYTHON_AIOLOGSTASH_LICENSE = MIT
PYTHON_AIOLOGSTASH_LICENSE_FILES = LICENSE

$(eval $(python-package))
