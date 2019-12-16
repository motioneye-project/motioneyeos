################################################################################
#
# mender
#
################################################################################

MENDER_VERSION = 2.1.2
MENDER_SITE = https://github.com/mendersoftware/mender/archive
MENDER_SOURCE = $(MENDER_VERSION).tar.gz
MENDER_LICENSE = Apache-2.0, BSD-2-Clause, BSD-3-Clause, ISC, MIT, OLDAP-2.8

# Vendor license paths generated with:
#    awk '{print $2}' LIC_FILES_CHKSUM.sha256 | grep vendor
MENDER_LICENSE_FILES = \
	LICENSE \
	LIC_FILES_CHKSUM.sha256 \
	vendor/github.com/mendersoftware/mendertesting/LICENSE \
	vendor/github.com/mendersoftware/log/LICENSE \
	vendor/github.com/mendersoftware/scopestack/LICENSE \
	vendor/github.com/mendersoftware/mender-artifact/LICENSE \
	vendor/github.com/pkg/errors/LICENSE \
	vendor/github.com/pmezard/go-difflib/LICENSE \
	vendor/golang.org/x/crypto/LICENSE \
	vendor/golang.org/x/sys/LICENSE \
	vendor/golang.org/x/net/LICENSE \
	vendor/github.com/bmatsuo/lmdb-go/LICENSE.md \
	vendor/golang.org/x/text/LICENSE \
	vendor/github.com/remyoudompheng/go-liblzma/LICENSE \
	vendor/github.com/davecgh/go-spew/LICENSE \
	vendor/github.com/sirupsen/logrus/LICENSE \
	vendor/github.com/stretchr/testify/LICENSE \
	vendor/github.com/stretchr/testify/LICENCE.txt \
	vendor/github.com/stretchr/objx/LICENSE.md \
	vendor/github.com/ungerik/go-sysfs/LICENSE \
	vendor/github.com/konsorten/go-windows-terminal-sequences/LICENSE \
	vendor/github.com/bmatsuo/lmdb-go/LICENSE.mdb.md

MENDER_DEPENDENCIES = xz

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
	$(foreach f,hostinfo network os rootfs-type, \
		$(INSTALL) -D -m 0755 $(@D)/support/mender-inventory-$(f) \
			$(TARGET_DIR)/usr/share/mender/inventory/mender-inventory-$(f)
	)

	$(INSTALL) -D -m 0755 package/mender/artifact_info \
			$(TARGET_DIR)/etc/mender/artifact_info

	$(INSTALL) -D -m 0755 package/mender/device_type \
			$(TARGET_DIR)/etc/mender/device_type

	mkdir -p $(TARGET_DIR)/var/lib
	ln -snf /var/run/mender $(TARGET_DIR)/var/lib/mender
endef

MENDER_POST_INSTALL_TARGET_HOOKS += MENDER_INSTALL_CONFIG_FILES

define MENDER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(MENDER_PKGDIR)/mender.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mender.service
endef

define MENDER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/mender/S42mender \
		$(TARGET_DIR)/etc/init.d/S42mender
endef

$(eval $(golang-package))
