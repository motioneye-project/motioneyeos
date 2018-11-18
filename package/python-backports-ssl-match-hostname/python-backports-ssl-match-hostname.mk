################################################################################
#
# python-backports-ssl-match-hostname
#
################################################################################

PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_VERSION = 3.5.0.1
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_SOURCE = backports.ssl_match_hostname-$(PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_VERSION).tar.gz
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_SITE = https://pypi.python.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_SETUP_TYPE = distutils
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_LICENSE = Python-2.0
PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_LICENSE_FILES = backports/ssl_match_hostname/LICENSE.txt

$(eval $(python-package))
