#############################################################
#
# apr
#
#############################################################
APR_VERSION = 1.4.6
APR_SITE = http://archive.apache.org/dist/apr
APR_INSTALL_STAGING = YES
APR_CONF_ENV = \
	ac_cv_file__dev_zero=yes \
	ac_cv_func_setpgrp_void=yes \
	apr_cv_process_shared_works=yes \
	apr_cv_mutex_robust_shared=no \
	apr_cv_tcp_nodelay_with_cork=yes \
	ac_cv_sizeof_struct_iovec=8 \
	apr_cv_mutex_recursive=yes

$(eval $(autotools-package))
