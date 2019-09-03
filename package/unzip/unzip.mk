################################################################################
#
# unzip
#
################################################################################

UNZIP_VERSION = 60
UNZIP_SOURCE = unzip$(UNZIP_VERSION).tgz
UNZIP_SITE = ftp://ftp.info-zip.org/pub/infozip/src
UNZIP_LICENSE = Info-ZIP
UNZIP_LICENSE_FILES = LICENSE

UNZIP_PATCH = \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/07-increase-size-of-cfactorstr.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/08-allow-greater-hostver-values.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/09-cve-2014-8139-crc-overflow.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/10-cve-2014-8140-test-compr-eb.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/11-cve-2014-8141-getzip64data.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/12-cve-2014-9636-test-compr-eb.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/14-cve-2015-7696.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/15-cve-2015-7697.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/16-fix-integer-underflow-csiz-decrypted.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/17-restore-unix-timestamps-accurately.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/18-cve-2014-9913-unzip-buffer-overflow.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/19-cve-2016-9844-zipinfo-buffer-overflow.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/20-cve-2018-1000035-unzip-buffer-overflow.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/21-fix-warning-messages-on-big-files.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/22-cve-2019-13232-fix-bug-in-undefer-input.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/23-cve-2019-13232-zip-bomb-with-overlapped-entries.patch \
	https://sources.debian.org/data/main/u/unzip/6.0-25/debian/patches/24-cve-2019-13232-do-not-raise-alert-for-misplaced-central-directory.patch

$(eval $(cmake-package))
