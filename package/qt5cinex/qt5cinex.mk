################################################################################
#
# qt5cinex
#
################################################################################

QT5CINEX_VERSION = 1.0
QT5CINEX_SITE = http://quitcoding.com/download

ifeq ($(BR2_PACKAGE_QT5CINEX_HD),y)
QT5CINEX_HD = "rpi_"
endif

QT5CINEX_SOURCE = Qt5_CinematicExperience_$(QT5CINEX_HD)$(QT5CINEX_VERSION).tgz
QT5CINEX_DEPENDENCIES = qt5base qt5declarative

QT5CINEX_LICENSE = CC-BY-3.0
QT5CINEX_LICENSE_FILES = README

define QT5CINEX_CONFIGURE_CMDS
	cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake
endef

define QT5CINEX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

# In addition to the Cinematic Experience itself, we also install a
# wrapper shell script to /usr/bin: the Cinematic Experience binary
# wants its resource files to be available directly under a contents/
# sub-directory, which isn't very practical to install in /usr/bin/.
define QT5CINEX_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/Qt5_CinematicExperience \
		$(TARGET_DIR)/usr/share/Qt5/CinematicExperience/Qt5_CinematicExperience
	$(INSTALL) -D -m 0664 $(@D)/Qt5_CinematicExperience.qml \
		$(TARGET_DIR)/usr/share/Qt5/CinematicExperience/Qt5_CinematicExperience.qml
	cp -dpfr $(@D)/content $(TARGET_DIR)/usr/share/Qt5/CinematicExperience/content
	$(INSTALL) -m 0755 -D package/qt5cinex/CinematicExperience-demo \
		$(TARGET_DIR)/usr/bin/CinematicExperience-demo
endef

$(eval $(generic-package))
