################################################################################
#
# libsndfile
#
################################################################################

LIBSNDFILE_VERSION = 1.0.28
LIBSNDFILE_SITE = http://www.mega-nerd.com/libsndfile/files
LIBSNDFILE_INSTALL_STAGING = YES
LIBSNDFILE_LICENSE = LGPL-2.1+
LIBSNDFILE_LICENSE_FILES = COPYING

# 0001-double64_init-Check-psf-sf.channels-against-upper-bo.patch
LIBSNDFILE_IGNORE_CVES += CVE-2017-14634
# 0002-Check-MAX_CHANNELS-in-sndfile-deinterleave.patch
LIBSNDFILE_IGNORE_CVES += CVE-2018-13139 CVE-2018-19432
# 0003-a-ulaw-fix-multiple-buffer-overflows-432.patch
LIBSNDFILE_IGNORE_CVES += \
	CVE-2017-14245 CVE-2017-14246 CVE-2017-17456 CVE-2017-17457 \
	CVE-2018-19661 CVE-2018-19662
# disputed, https://github.com/erikd/libsndfile/issues/398
LIBSNDFILE_IGNORE_CVES += CVE-2018-13419
# 0004-src-wav.c-Fix-heap-read-overflow.patch
LIBSNDFILE_IGNORE_CVES += CVE-2018-19758
# 0005-wav_write_header-don-t-read-past-the-array-end.patch
LIBSNDFILE_IGNORE_CVES += CVE-2019-3832
# 0006-src-aiff.c-Fix-a-buffer-read-overflow.patch
LIBSNDFILE_IGNORE_CVES += CVE-2017-6892
# 0007-FLAC-Fix-a-buffer-read-overrun.patch
LIBSNDFILE_IGNORE_CVES += CVE-2017-8361
# 0008-src-flac.c-Fix-a-buffer-read-overflow.patch
LIBSNDFILE_IGNORE_CVES += CVE-2017-8362 CVE-2017-8365
# 0009-src-flac-c-Fix-another-memory-leak.patch
LIBSNDFILE_IGNORE_CVES += CVE-2017-8363
# 0010-src-common-c-Fix-heap-buffer-overflows-when-writing-strings-in.patch
LIBSNDFILE_IGNORE_CVES += CVE-2017-12562

LIBSNDFILE_CONF_OPTS = \
	--disable-sqlite \
	--disable-alsa \
	--disable-external-libs \
	--disable-full-suite

$(eval $(autotools-package))
