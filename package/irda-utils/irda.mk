#############################################################
#
# irda-utils
#
#############################################################
IRDA_UTILS_VERSION:=0.9.18
IRDA_UTILS_SOURCE:=irda-utils-$(IRDA_UTILS_VERSION).tar.gz
IRDA_UTILS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/irda/$(IRDA_UTILS_SOURCE)
IRDA_UTILS_DIR:=$(BUILD_DIR)/irda-utils-$(IRDA_UTILS_VERSION)

ifeq ($(IRDA_IRATTACH),y)
IRDA_DIRS += irattach
endif
ifeq ($(IRDA_IRDAPING),y)
IRDA_DIRS += irdaping
endif
ifeq ($(IRDA_IRNETD),y)
IRDA_DIRS += irnetd
endif
ifeq ($(IRDA_PSION),y)
IRDA_DIRS += psion
endif
ifeq ($(IRDA_TEKRAM),y)
IRDA_DIRS += tekram
endif
ifeq ($(IRDA_FINDCHIP),y)
IRDA_DIRS += findchip
endif
ifeq ($(IRDA_IRDADUMP),y)
IRDA_DIRS += irdadump
endif
ifeq ($(IRDA_SMCINIT),y)
IRDA_DIRS += smcinit
endif

IRDA_UTILS_MAKE_OPT:=-e "DIRS=$(IRDA_DIRS)"
IRDA_UTILS_MAKE_ENV:=CC=$(TARGET_CC) LD=$(TARGET_LD) AR=$(TARGET_AR) RANLIB=$(TARGET_RANLIB) ROOT=$(TARGET_DIR) PREFIX=$(TARGET_DIR)

# Since there is no configure-script

$(IRDA_UTILS_DIR)/.configured: $(IRDA_UTILS_DIR)/.patched
	touch $@

irda-utils: uclibc $(DL_DIR)/$(IRDA_UTILS_SOURCE) $(IRDA_UTILS_DIR)/.installed

irda-utils-clean: $(IRDA_UTILS_DIR)/.clean

irda-utils-dirclean: $(IRDA_UTILS_DIR)/.dirclean

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_IRDA_UTILS),y)
TARGETS+=irda-utils
endif
