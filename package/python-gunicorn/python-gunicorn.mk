################################################################################
#
# python-gunicorn
#
################################################################################

PYTHON_GUNICORN_VERSION = 19.9.0
PYTHON_GUNICORN_SOURCE = gunicorn-$(PYTHON_GUNICORN_VERSION).tar.gz
PYTHON_GUNICORN_SITE = https://files.pythonhosted.org/packages/47/52/68ba8e5e8ba251e54006a49441f7ccabca83b6bef5aedacb4890596c7911
PYTHON_GUNICORN_SETUP_TYPE = setuptools
PYTHON_GUNICORN_LICENSE = MIT
PYTHON_GUNICORN_LICENSE_FILES = LICENSE

# At the end of the build, we try to compile all py files using the host python
# that has been built.
# The GAIO HTTP Worker is only compatible with Python3.4.2 and up. So don't try
# to compile it with python 2.x
ifeq ($(BR2_PACKAGE_PYTHON),y)
define PYTHON_GUNICORN_REMOVE_GAIO_WORKER
	find $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages/ \
		-name "_gaiohttp.py" -exec rm -f {} \;
endef
PYTHON_GUNICORN_POST_INSTALL_TARGET_HOOKS += PYTHON_GUNICORN_REMOVE_GAIO_WORKER
endif

$(eval $(python-package))
