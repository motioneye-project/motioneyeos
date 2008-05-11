#############################################################
#
# input-tools
#
#############################################################

INPUT_TOOLS_VERSION:=20051019
INPUT_TOOLS_SOURCE:=joystick_$(INPUT_TOOLS_VERSION).orig.tar.gz
INPUT_TOOLS_PATCH:=joystick_$(INPUT_TOOLS_VERSION)-2.diff.gz
INPUT_TOOLS_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/j/joystick/
INPUT_TOOLS_DIR:=$(BUILD_DIR)/joystick-$(INPUT_TOOLS_VERSION).orig
INPUT_TOOLS_CAT:=$(ZCAT)

INPUT_TOOLS_TARGETS-y:=

INPUT_TOOLS_TARGETS-$(BR2_PACKAGE_INPUT_TOOLS_EVTEST) += evtest
INPUT_TOOLS_TARGETS-$(BR2_PACKAGE_INPUT_TOOLS_INPUTATTACH) += inputattach
INPUT_TOOLS_TARGETS-$(BR2_PACKAGE_INPUT_TOOLS_JSCAL) += jscal
INPUT_TOOLS_TARGETS-$(BR2_PACKAGE_INPUT_TOOLS_JSTEST) += jstest

INPUT_TOOLS_TARGETS := $(addprefix $(TARGET_DIR)/usr/bin/, $(INPUT_TOOLS_TARGETS-y))
INPUT_TOOLS_SOURCES := $(addprefix $(INPUT_TOOLS_DIR)/utils/, \
	$(addsuffix .c, $(INPUT_TOOLS_TARGETS-y)))

$(DL_DIR)/$(INPUT_TOOLS_SOURCE):
	$(WGET) -P $(DL_DIR) $(INPUT_TOOLS_SITE)/$(@F)

$(DL_DIR)/$(INPUT_TOOLS_PATCH):
	$(WGET) -P $(DL_DIR) $(INPUT_TOOLS_SITE)/$(@F)

$(INPUT_TOOLS_DIR)/.unpacked: $(DL_DIR)/$(INPUT_TOOLS_SOURCE) $(DL_DIR)/$(INPUT_TOOLS_PATCH)
	$(INPUT_TOOLS_CAT) $(DL_DIR)/$(INPUT_TOOLS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(INPUT_TOOLS_PATCH),)
	(cd $(INPUT_TOOLS_DIR) && $(INPUT_TOOLS_CAT) $(DL_DIR)/$(INPUT_TOOLS_PATCH) | patch -p1)
endif
	toolchain/patch-kernel.sh $(INPUT_TOOLS_DIR) package/input-tools/ \*.patch
	touch $@

$(INPUT_TOOLS_SOURCES): $(INPUT_TOOLS_DIR)/.unpacked

$(INPUT_TOOLS_DIR)/utils/%: $(INPUT_TOOLS_DIR)/utils/%.c
	$(TARGET_CC) $(TARGET_CFLAGS) -o $@ $^

$(INPUT_TOOLS_TARGETS): $(TARGET_DIR)/usr/bin/%: $(INPUT_TOOLS_DIR)/utils/%
	cp -dpf $^ $@
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

input-tools: uclibc $(INPUT_TOOLS_TARGETS)

input-tools-source: $(DL_DIR)/$(INPUT_TOOLS_SOURCE) $(DL_DIR)/$(INPUT_TOOLS_PATCH)

input-tools-unpacked: $(INPUT_TOOLS_DIR)/.unpacked

input-tools-clean:
	rm -f $(INPUT_TOOLS_TARGETS)

input-tools-dirclean:
	rm -rf $(INPUT_TOOLS_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_INPUT_TOOLS)),y)
TARGETS+=input-tools
endif
