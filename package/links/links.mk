#############################################################
#
# links (text based web browser)
#
#############################################################
LINKS_VERSION:=1.01pre1-no-ssl
LINKS_SITE:=http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/links/download/no-ssl
LINKS_SOURCE:=links-$(LINKS_VERSION).tar.gz

LINKS_CONF_OPT = --localstatedir=/tmp

define LINKS_INSTALL_TARGET_CMDS
	install -c $(@D)/links $(TARGET_DIR)/usr/bin/links
endef

$(eval $(call AUTOTARGETS,package,links))
