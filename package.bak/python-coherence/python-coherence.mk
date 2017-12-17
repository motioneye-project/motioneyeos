################################################################################
#
# python-coherence
#
################################################################################

PYTHON_COHERENCE_VERSION = 0.6.6.2
PYTHON_COHERENCE_SITE = $(call github,coherence-project,Coherence,Coherence-$(PYTHON_COHERENCE_VERSION))
PYTHON_COHERENCE_SETUP_TYPE = setuptools
PYTHON_COHERENCE_LICENSE = MIT
PYTHON_COHERENCE_LICENSE_FILES = LICENCE
PYTHON_COHERENCE_DEPENDENCIES = python-twisted python-zope-interface python-pyasn

$(eval $(python-package))
