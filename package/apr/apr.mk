################################################################################
#
# apr
#
################################################################################

APR_VERSION = 1.4.6
APR_SITE = http://archive.apache.org/dist/apr
APR_LICENSE = Apache-2.0
APR_LICENSE_FILES = LICENSE
APR_INSTALL_STAGING = YES
APR_CONF_ENV = \
	ac_cv_file__dev_zero=yes \
	ac_cv_func_setpgrp_void=yes \
	apr_cv_process_shared_works=yes \
	apr_cv_mutex_robust_shared=no \
	apr_cv_tcp_nodelay_with_cork=yes \
	ac_cv_sizeof_struct_iovec=8 \
	apr_cv_mutex_recursive=yes
APR_CONFIG_SCRIPTS = apr-1-config

define APR_CLEANUP_UNNEEDED_FILES
	$(RM) -rf $(TARGET_DIR)/usr/build-1/
endef

APR_POST_INSTALL_TARGET_HOOKS += APR_CLEANUP_UNNEEDED_FILES

define APR_FIXUP_RULES_MK
	$(SED) 's%apr_builddir=%apr_builddir=$(STAGING_DIR)%' \
		$(STAGING_DIR)/usr/build-1/apr_rules.mk
	$(SED) 's%apr_builders=%apr_builders=$(STAGING_DIR)%' \
		$(STAGING_DIR)/usr/build-1/apr_rules.mk
endef

APR_POST_INSTALL_STAGING_HOOKS += APR_FIXUP_RULES_MK

$(eval $(autotools-package))
