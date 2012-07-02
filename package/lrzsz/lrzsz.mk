#############################################################
#
# lrzsz (provides zmodem)
#
#############################################################
# Copyright (C) 2001-2005 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
# USA
LRZSZ_VERSION:=0.12.20
LRZSZ_SITE:=http://www.ohse.de/uwe/releases
LRZSZ_SOURCE:=lrzsz-$(LRZSZ_VERSION).tar.gz

LRZSR_CONF_OPT = --disable-timesync

define LRZSZ_POST_CONFIGURE_HOOKS
	$(SED) "s/-lnsl//;" $(@D)/src/Makefile
	$(SED) "s~\(#define ENABLE_SYSLOG.*\)~/* \1 */~;" $(@D)/config.h
endef

define LRZSZ_BUILD_HOOKS
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" prefix="$(TARGET_DIR)" -C $(@D)
endef

define LRZSZ_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/src/lrz $(TARGET_DIR)/usr/bin/rz
	$(INSTALL) -m 0755 -D $(@D)/src/lsz $(TARGET_DIR)/usr/bin/sz
	ln -sf rz $(TARGET_DIR)/usr/bin/lrz
	ln -sf sz $(TARGET_DIR)/usr/bin/lsz
endef

define LRZSZ_CLEAN_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,rz sz lrz lsz)
	-$(MAKE) -C $(@D) clean
endef

$(eval $(autotools-package))
