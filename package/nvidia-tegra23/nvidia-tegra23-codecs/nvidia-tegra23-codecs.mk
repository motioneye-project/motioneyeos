################################################################################
#
# nvidia-tegra23-codecs
#
################################################################################

NVIDIA_TEGRA23_CODECS_VERSION = $(NVIDIA_TEGRA23_VERSION)
NVIDIA_TEGRA23_CODECS_SOURCE = $(NVIDIA_TEGRA23_BASE)-codecs_R$(NVIDIA_TEGRA23_CODECS_VERSION)_armhf.tbz2
NVIDIA_TEGRA23_CODECS_SITE = $(NVIDIA_TEGRA23_SITE)
NVIDIA_TEGRA23_CODECS_LICENSE = NVIDIA(r) Tegra(r) Software License Agreement
NVIDIA_TEGRA23_CODECS_LICENSE_FILES = Tegra_Software_License_Agreement-Tegra-Linux-codecs.txt
NVIDIA_TEGRA23_CODECS_REDISTRIBUTE = NO

# The archive contains an archive with the firmware codecs
define NVIDIA_TEGRA23_CODECS_EXTRACT_CMDS
	$(INSTALL) -d $(@D)
	$(call suitable-extractor,$(NVIDIA_TEGRA23_CODECS_SOURCE)) \
		$(NVIDIA_TEGRA23_CODECS_DL_DIR)/$(NVIDIA_TEGRA23_CODECS_SOURCE) | \
	$(TAR) --strip-components=0 -C $(@D) $(TAR_OPTIONS) -
	$(INSTALL) -d $(@D)/restricted_codecs
	$(call suitable-extractor,$(@D)/restricted_codecs.tbz2) \
		$(@D)/restricted_codecs.tbz2 | \
	$(TAR) --strip-components=0 -C $(@D)/restricted_codecs/ $(TAR_OPTIONS) -
endef

define NVIDIA_TEGRA23_CODECS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/
	cp -dpfr $(@D)/restricted_codecs/lib/firmware/*.axf \
		$(TARGET_DIR)/lib/firmware/
endef

$(eval $(generic-package))
