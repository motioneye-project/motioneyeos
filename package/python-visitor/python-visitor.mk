################################################################################
#
# python-visitor
#
################################################################################

PYTHON_VISITOR_VERSION = 0.1.3
PYTHON_VISITOR_SOURCE = visitor-$(PYTHON_VISITOR_VERSION).tar.gz
PYTHON_VISITOR_SITE = https://pypi.python.org/packages/d7/58/785fcd6de4210049da5fafe62301b197f044f3835393594be368547142b0
PYTHON_VISITOR_SETUP_TYPE = setuptools
PYTHON_VISITOR_LICENSE = MIT
PYTHON_VISITOR_LICENSE_FILES = LICENSE

$(eval $(python-package))
