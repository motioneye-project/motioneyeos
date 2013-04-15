QT5_VERSION = 5.0.2
QT5_SITE = http://releases.qt-project.org/qt5/$(QT5_VERSION)/submodules/
include package/qt5/*/*.mk

define QT5_LA_PRL_FILES_FIXUP
	for i in $$(find $(STAGING_DIR)/usr/lib* -name "libQt5*.la"); do \
		$(SED) "s:\(['= ]\)/usr:\\1$(STAGING_DIR)/usr:g" $$i; \
		$(SED) "/^dependency_libs=/s%-L/usr/lib %%g" $$i ; \
	done
	for i in $$(find $(STAGING_DIR)/usr/lib* -name "libQt5*.prl"); do \
		$(SED) "s%-L/usr/lib%%" $$i; \
	done
endef
