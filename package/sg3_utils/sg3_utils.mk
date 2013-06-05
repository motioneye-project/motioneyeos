################################################################################
#
# sg3_utils
#
################################################################################

SG3_UTILS_VERSION = 1.34
SG3_UTILS_SITE    = http://sg.danny.cz/sg/p/
SG3_UTILS_LICENSE = BSD-3c
# utils progs are GPLv2+ licenced
ifeq ($(BR2_PACKAGE_SG3_UTILS_PROGS),y)
SG3_UTILS_LICENSE += GPLv2+
endif
SG3_UTILS_LICENSE_FILES = COPYING BSD_LICENSE

# install the libsgutils2 library
SG3_UTILS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_SG3_UTILS_PROGS),)
define SG3_UTILS_REMOVE_PROGS
	for prog in \
		dd decode_sense emc_trespass format get_config \
		get_lba_status ident inq logs luns map26 \
		map sgm_dd modes opcodes sgp_dd persist prevent \
		raw rbuf rdac read readcap read_block_limits \
		read_buffer read_long reassign referrals \
		requests reset rmsn rtpg safte sanitize \
		sat_identify sat_phy_event sat_set_features scan \
		senddiag ses start stpg sync test_rwbuf turs \
		unmap verify vpd write_buffer write_long \
		write_same wr_mode ; do \
		$(RM) $(TARGET_DIR)/usr/bin/sg_$${prog} ; \
	done
	$(RM) $(TARGET_DIR)/usr/bin/sginfo
endef

SG3_UTILS_POST_INSTALL_TARGET_HOOKS += SG3_UTILS_REMOVE_PROGS
endif

$(eval $(autotools-package))
