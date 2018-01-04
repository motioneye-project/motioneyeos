################################################################################
#
# daq
#
################################################################################

DAQ_VERSION = 2.0.6
DAQ_SITE = https://www.snort.org/downloads/snort
DAQ_SOURCE = daq-$(DAQ_VERSION).tar.gz
DAQ_LICENSE = GPL-2.0
DAQ_LICENSE_FILES = COPYING
DAQ_INSTALL_STAGING = YES
DAQ_DEPENDENCIES = libdnet

# package does not build in parallel due to improper make rules
# related to the generation of the tokdefs.h header file
DAQ_MAKE = $(MAKE1)

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
DAQ_DEPENDENCIES += libpcap
# assume these flags are available to prevent configure from running
# test programs while cross compiling
DAQ_CONF_ENV += \
	ac_cv_lib_pcap_pcap_lib_version=yes \
	daq_cv_libpcap_version_1x=yes
DAQ_CONF_OPTS += --enable-pcap-module
else
DAQ_CONF_OPTS += --disable-pcap-module
endif

$(eval $(autotools-package))
