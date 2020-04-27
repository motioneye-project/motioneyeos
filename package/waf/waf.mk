################################################################################
#
# waf
#
################################################################################

WAF_VERSION = 2.0.20
WAF_SOURCE = waf-$(WAF_VERSION)
WAF_SITE = https://waf.io

define HOST_WAF_EXTRACT_CMDS
	$(INSTALL) -D -m 0755 $(HOST_WAF_DL_DIR)/waf-$(WAF_VERSION) $(@D)/waf
endef

define HOST_WAF_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/waf $(HOST_DIR)/bin/waf
endef

$(eval $(host-generic-package))
