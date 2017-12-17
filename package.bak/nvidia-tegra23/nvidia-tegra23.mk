################################################################################
#
# nvidia-tegra23
#
################################################################################

NVIDIA_TEGRA23_VERSION = 16.5

ifeq ($(BR2_PACKAGE_NVIDIA_TEGRA23_TEGRA2),y)
NVIDIA_TEGRA23_SITE = http://developer.download.nvidia.com/mobile/tegra/l4t/r16.5.0/ventana_release_armhf
NVIDIA_TEGRA23_BASE = Tegra20_Linux
endif
ifeq ($(BR2_PACKAGE_NVIDIA_TEGRA23_TEGRA3),y)
NVIDIA_TEGRA23_SITE = http://developer.download.nvidia.com/mobile/tegra/l4t/r16.5.0/cardhu_release_armhf
NVIDIA_TEGRA23_BASE = Tegra30_Linux
endif

include $(sort $(wildcard package/nvidia-tegra23/*/*.mk))
