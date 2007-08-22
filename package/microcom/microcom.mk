#############################################################
#
# microcom terminal emulator
#
# Maintainer: Tim Riker <Tim@Rikers.org>
#
#############################################################
# Copyright (C) 2001-2003 by Erik Andersen <andersen@codepoet.org>
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

# TARGETS
# http://microcom.port5.com/m102.tar.gz
MICROCOM_VERSION:=1.02
MICROCOM_SITE:=http://microcom.port5.com/
MICROCOM_SOURCE:=m102.tar.gz
MICROCOM_DIR:=$(BUILD_DIR)/microcom-$(MICROCOM_VERSION)

$(DL_DIR)/$(MICROCOM_SOURCE):
	$(WGET) -P $(DL_DIR) $(MICROCOM_SITE)/$(MICROCOM_SOURCE)

microcom-source: $(DL_DIR)/$(MICROCOM_SOURCE)

$(MICROCOM_DIR)/.unpacked: $(DL_DIR)/$(MICROCOM_SOURCE)
	mkdir -p $(MICROCOM_DIR)
	$(ZCAT) $(DL_DIR)/$(MICROCOM_SOURCE) | tar -C $(MICROCOM_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MICROCOM_DIR) package/microcom/ \*.patch
	touch $@

$(MICROCOM_DIR)/.configured: $(MICROCOM_DIR)/.unpacked
	$(SED) 's~gcc~$$(CC)~' -e 's~-O~$$(CFLAGS)~' $(MICROCOM_DIR)/Makefile
	touch $@

$(MICROCOM_DIR)/microcom: $(MICROCOM_DIR)/.configured
ifeq ($(BR2_PREFER_IMA),y)
	(cd $(MICROCOM_DIR); \
	 $(TARGET_CC) $(TARGET_CFLAGS) $(CFLAGS_COMBINE) \
	 	$(CFLAGS_WHOLE_PROGRAM) -o $@ $(wildcard $(MICROCOM_DIR)/*.c); \
	)
else
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(MICROCOM_DIR)
endif
	$(STRIP) $(STRIP_STRIP_ALL) $@

$(TARGET_DIR)/usr/bin/microcom: $(MICROCOM_DIR)/microcom
	install -c $(MICROCOM_DIR)/microcom $(TARGET_DIR)/usr/bin/microcom

microcom-clean: 
	rm -f $(MICROCOM_DIR)/*.o $(MICROCOM_DIR)/microcom \
		$(TARGET_DIR)/usr/bin/microcom

microcom-dirclean: 
	rm -rf $(MICROCOM_DIR) 

microcom: uclibc $(TARGET_DIR)/usr/bin/microcom 

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MICROCOM)),y)
TARGETS+=microcom
endif
