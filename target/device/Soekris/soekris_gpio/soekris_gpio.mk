#############################################################
#
# Soekris gpio, led and temp sensor driver
#
#############################################################
# Copyright (C) 2005 by John D. Blair <jdb@moship.net>
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

SOEKRIS_GPIO_VER:=1.3.2
SOEKRIS_GPIO_DIR:=$(BUILD_DIR)/gpio-$(SOEKRIS_GPIO_VER)
SOEKRIS_GPIO_SITE:=http://soekris.hejl.de
SOEKRIS_GPIO_SOURCE:=gpio-$(SOEKRIS_GPIO_VER).tar.gz
SOEKRIS_GPIO_CAT:=zcat
SOEKRIS_GPIO_MODULE_DIR=lib/modules/$(LINUX_VERSION)/kernel/drivers/soekris/

$(DL_DIR)/$(SOEKRIS_GPIO_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SOEKRIS_GPIO_SITE)/$(SOEKRIS_GPIO_SOURCE)

soekris_gpio-source: $(DL_DIR)/$(SOEKRIS_GPIO_SOURCE)

$(SOEKRIS_GPIO_DIR)/.unpacked: $(DL_DIR)/$(SOEKRIS_GPIO_SOURCE)
	$(SOEKRIS_GPIO_CAT) $(DL_DIR)/$(SOEKRIS_GPIO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(SOEKRIS_GPIO_DIR)/.unpacked

$(SOEKRIS_GPIO_DIR)/.compiled: $(SOEKRIS_GPIO_DIR)/.unpacked $(LINUX_KERNEL)
	# overwrite distributed Makefile
	cp target/device/Soekris/soekris_gpio/Makefile $(SOEKRIS_GPIO_DIR)
		LINUX_SOURCE_DIR=$(LINUX_SOURCE_DIR) \
		LINUX_KCONFIG=../../$(LINUX_KCONFIG) \
		CC=$(TARGET_CC) \
		LD=$(TARGET_CROSS)ld \
		$(MAKE) -C $(SOEKRIS_GPIO_DIR)
	touch $(SOEKRIS_GPIO_DIR)/.compiled

# 4801driver.o is used as shorthand for all the modules
$(TARGET_DIR)/$(SOEKRIS_GPIO_MODULE_DIR)/4801driver.o: $(SOEKRIS_GPIO_DIR)/.compiled
	mkdir -p $(TARGET_DIR)/$(SOEKRIS_GPIO_MODULE_DIR)
	cp $(SOEKRIS_GPIO_DIR)/4501driver.o $(TARGET_DIR)/$(SOEKRIS_GPIO_MODULE_DIR)
	cp $(SOEKRIS_GPIO_DIR)/4801driver.o $(TARGET_DIR)/$(SOEKRIS_GPIO_MODULE_DIR)
	cp $(SOEKRIS_GPIO_DIR)/common.o $(TARGET_DIR)/$(SOEKRIS_GPIO_MODULE_DIR)
	cp $(SOEKRIS_GPIO_DIR)/gpio.o $(TARGET_DIR)/$(SOEKRIS_GPIO_MODULE_DIR)
	# rebuild the modules.dep file so it includes the soekris drivers
	/sbin/depmod -r -a -b $(TARGET_DIR) -F $(LINUX_DIR)/System.map $(LINUX_VERSION)

soekris_gpio: $(TARGET_DIR)/$(SOEKRIS_GPIO_MODULE_DIR)/4801driver.o

soekris_gpio-clean:
	-$(MAKE) -C $(SOEKRIS_GPIO_DIR) clean

soekris_gpio-dirclean:
	rm -rf $(SOEKRIS_GPIO_DIR)
