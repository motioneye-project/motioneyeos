################################################################################
#
# mender
#
################################################################################

MENDER_VERSION = 1.4.0
MENDER_SITE = $(call github,mendersoftware,mender,$(MENDER_VERSION))
MENDER_LICENSE = Apache-2.0, BSD-2-Clause, BSD-3-Clause, ISC, MIT, OLDAP-2.8

# Vendor license paths generated with:
#    awk '{print $2}' LIC_FILES_CHKSUM.sha256 | grep vendor
MENDER_LICENSE_FILES = \
	LICENSE \
	LIC_FILES_CHKSUM.sha256 \
	vendor/github.com/mendersoftware/mendertesting/LICENSE \
	vendor/github.com/mendersoftware/log/LICENSE \
	vendor/github.com/mendersoftware/log/COPYING \
	vendor/github.com/mendersoftware/scopestack/LICENSE \
	vendor/github.com/mendersoftware/scopestack/COPYING \
	vendor/github.com/mendersoftware/mender-artifact/LICENSE \
	vendor/github.com/pkg/errors/LICENSE \
	vendor/github.com/pmezard/go-difflib/LICENSE \
	vendor/golang.org/x/sys/LICENSE \
	vendor/golang.org/x/net/LICENSE \
	vendor/github.com/bmatsuo/lmdb-go/LICENSE.md \
	vendor/github.com/davecgh/go-spew/LICENSE \
	vendor/github.com/Sirupsen/logrus/LICENSE \
	vendor/github.com/stretchr/testify/LICENSE \
	vendor/github.com/stretchr/testify/LICENCE.txt \
	vendor/github.com/stretchr/objx/LICENSE.md \
	vendor/github.com/ungerik/go-sysfs/LICENSE \
	vendor/github.com/bmatsuo/lmdb-go/LICENSE.mdb.md

MENDER_LDFLAGS = -X main.Version=$(MENDER_VERSION)

define MENDER_INSTALL_CONFIG_FILES
	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/mender/scripts
	echo -n "2" > $(TARGET_DIR)/etc/mender/scripts/version

	$(INSTALL) -D -m 0644 $(MENDER_PKGDIR)/mender.conf \
		$(TARGET_DIR)/etc/mender/mender.conf
	$(INSTALL) -D -m 0644 $(MENDER_PKGDIR)/server.crt \
		$(TARGET_DIR)/etc/mender/server.crt

	$(INSTALL) -D -m 0755 $(@D)/support/mender-device-identity \
		$(TARGET_DIR)/usr/share/mender/identity/mender-device-identity
	$(foreach f,hostinfo network, \
		$(INSTALL) -D -m 0755 $(@D)/support/mender-inventory-$(f) \
			$(TARGET_DIR)/usr/share/mender/inventory/mender-inventory-$(f)
	)
endef

MENDER_POST_INSTALL_TARGET_HOOKS += MENDER_INSTALL_CONFIG_FILES

define MENDER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(MENDER_PKGDIR)/mender.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mender.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/mender.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/mender.service
endef

$(eval $(golang-package))
