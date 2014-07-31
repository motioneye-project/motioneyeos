QT5_VERSION_MAJOR = 5.3
QT5_VERSION = $(QT5_VERSION_MAJOR).1
QT5_SITE = http://download.qt-project.org/official_releases/qt/$(QT5_VERSION_MAJOR)/$(QT5_VERSION)/submodules
include $(sort $(wildcard package/qt5/*/*.mk))

define QT5_LA_PRL_FILES_FIXUP
	for i in $$(find $(STAGING_DIR)/usr/lib* -name "libQt5*.la"); do \
		$(SED)  "s:$(BASE_DIR):@BASE_DIR@:g" \
			-e "s:$(STAGING_DIR):@STAGING_DIR@:g" \
			-e "s:\(['= ]\)/usr:\\1@STAGING_DIR@/usr:g" \
			-e "s:@STAGING_DIR@:$(STAGING_DIR):g" \
			-e "s:@BASE_DIR@:$(BASE_DIR):g" \
			$$i ; \
		$(SED) "/^dependency_libs=/s%-L/usr/lib %%g" $$i ; \
	done
	for i in $$(find $(STAGING_DIR)/usr/lib* -name "libQt5*.prl"); do \
		$(SED) "s%-L/usr/lib%%" $$i; \
	done
endef
