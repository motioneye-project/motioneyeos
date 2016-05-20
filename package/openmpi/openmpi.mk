################################################################################
#
# openmpi
#
################################################################################

OPENMPI_VERSION_MAJOR = 1.10
OPENMPI_VERSION = $(OPENMPI_VERSION_MAJOR).2
OPENMPI_SITE = https://www.open-mpi.org/software/ompi/v$(OPENMPI_VERSION_MAJOR)/downloads
OPENMPI_SOURCE = openmpi-$(OPENMPI_VERSION).tar.bz2
OPENMPI_LICENSE = BSD-3c
OPENMPI_LICENSE_FILES = LICENSE
OPENMPI_INSTALL_STAGING = YES
OPENMPI_CONF_OPTS = --disable-vt

# Disable fortran by default until we add BR2_TOOLCHAIN_HAS_FORTRAN
# hidden symbol to our toolchain infrastructure
OPENMPI_CONF_OPTS += --enable-mpi-fortran=no

$(eval $(autotools-package))
