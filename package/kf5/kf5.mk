################################################################################
#
# kf5
#
################################################################################

KF5_VERSION_MAJOR = 5.47
KF5_VERSION = $(KF5_VERSION_MAJOR).0
KF5_SITE = https://download.kde.org/stable/frameworks/$(KF5_VERSION_MAJOR)

include $(sort $(wildcard package/kf5/*/*.mk))
