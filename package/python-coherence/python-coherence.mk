################################################################################
#
# python-coherence
#
################################################################################

PYTHON_COHERENCE_VERSION = b7856985fd496689ca1f9024925ae737297c00d1
PYTHON_COHERENCE_SITE = $(call github,coherence-project,Coherence,$(PYTHON_COHERENCE_VERSION))
PYTHON_COHERENCE_SETUP_TYPE = setuptools
PYTHON_COHERENCE_LICENSE = MIT
PYTHON_COHERENCE_LICENSE_FILES = LICENCE

$(eval $(python-package))
