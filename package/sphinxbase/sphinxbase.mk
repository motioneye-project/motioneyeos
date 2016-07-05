################################################################################
#
# sphinxbase
#
################################################################################

SPHINXBASE_VERSION = 5prealpha
SPHINXBASE_SITE = http://downloads.sourceforge.net/project/cmusphinx/sphinxbase/5prealpha
SPHINXBASE_LICENSE = BSD-2c
# Note http://sourceforge.net/p/cmusphinx/bugs/441/ "LICENSE file missing in"
# 5prealpha tarballs". The license is contained in the copyright notice at the
# top of each source file. For example:
SPHINXBASE_LICENSE_FILES = src/libsphinxbase/util/bio.c

SPHINXBASE_DEPENDENCIES = host-bison

SPHINXBASE_CONF_OPTS = --without-python --without-lapack

$(eval $(autotools-package))
