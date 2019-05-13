################################################################################
#
# ca-certificates
#
################################################################################

CA_CERTIFICATES_VERSION = 20190110
CA_CERTIFICATES_SOURCE = ca-certificates_$(CA_CERTIFICATES_VERSION).tar.xz
CA_CERTIFICATES_SITE = http://snapshot.debian.org/archive/debian/20190513T145054Z/pool/main/c/ca-certificates
CA_CERTIFICATES_DEPENDENCIES = host-openssl
# ca-certificates can be built with either python 2 or python 3
# but it must be at least python 2.7
CA_CERTIFICATES_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python)
CA_CERTIFICATES_LICENSE = GPL-2.0+ (script), MPL-2.0 (data)
CA_CERTIFICATES_LICENSE_FILES = debian/copyright

define CA_CERTIFICATES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean all
endef

define CA_CERTIFICATES_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/share/ca-certificates
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/ssl/certs
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR=$(TARGET_DIR)
	rm -f $(TARGET_DIR)/usr/sbin/update-ca-certificates

	# Remove any existing certificates under /etc/ssl/certs
	rm -f  $(TARGET_DIR)/etc/ssl/certs/*

	# Create symlinks to certificates under /etc/ssl/certs
	# and generate the bundle
	cd $(TARGET_DIR) ;\
	for i in `find usr/share/ca-certificates -name "*.crt" | LC_COLLATE=C sort` ; do \
		ln -sf ../../../$$i etc/ssl/certs/`basename $${i} .crt`.pem ;\
		cat $$i ;\
	done >$(@D)/ca-certificates.crt

	# Create symlinks to the certificates by their hash values
	$(HOST_DIR)/bin/c_rehash $(TARGET_DIR)/etc/ssl/certs

	# Install the certificates bundle
	$(INSTALL) -D -m 644 $(@D)/ca-certificates.crt \
		$(TARGET_DIR)/etc/ssl/certs/ca-certificates.crt
endef

$(eval $(generic-package))
