################################################################################
#
# python-backports-ssl-match-hostname
#
################################################################################

PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_VERSION = 3.7.0.1
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_SOURCE = backports.ssl_match_hostname-$(PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_VERSION).tar.gz
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_SITE = https://files.pythonhosted.org/packages/ff/2b/8265224812912bc5b7a607c44bf7b027554e1b9775e9ee0de8032e3de4b2
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_SETUP_TYPE = distutils
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_LICENSE = Python-2.0
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
