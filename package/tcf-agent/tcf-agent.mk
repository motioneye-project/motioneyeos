################################################################################
#
# tcf-agent
#
################################################################################

TCF_AGENT_VERSION = 1.7.0
# the tar.xz link was broken the time this file got authored
TCF_AGENT_SOURCE = org.eclipse.tcf.agent-$(TCF_AGENT_VERSION).tar.gz
TCF_AGENT_SITE = http://git.eclipse.org/c/tcf/org.eclipse.tcf.agent.git/snapshot
# see https://wiki.spdx.org/view/Legal_Team/License_List/Licenses_Under_Consideration
TCF_AGENT_LICENSE = BSD-3-Clause
TCF_AGENT_LICENSE_FILES = agent/edl-v10.html

TCF_AGENT_DEPENDENCIES = util-linux
TCF_AGENT_SUBDIR = agent

# there is not much purpose for the shared lib,
# if wont be used (unmodifed) outside the tcf-agent application
TCF_AGENT_CONF_OPTS = \
	-DBUILD_SHARED_LIBS=OFF \
	-DTCF_MACHINE=$(call qstrip,$(BR2_PACKAGE_TCF_AGENT_ARCH))

define TCF_AGENT_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/tcf-agent/tcf-agent.service \
		$(TARGET_DIR)/usr/lib/systemd/system/tcf-agent.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/tcf-agent.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/tcf-agent.service
endef

define TCF_AGENT_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/tcf-agent/S55tcf-agent \
		$(TARGET_DIR)/etc/init.d/S55tcf-agent
endef

$(eval $(cmake-package))
