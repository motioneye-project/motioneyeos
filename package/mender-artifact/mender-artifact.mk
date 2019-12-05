################################################################################
#
# host-mender-artifact
#
################################################################################

HOST_MENDER_ARTIFACT_VERSION = 3.2.1
HOST_MENDER_ARTIFACT_SITE = https://github.com/mendersoftware/mender-artifact/archive
HOST_MENDER_ARTIFACT_SOURCE = $(HOST_MENDER_ARTIFACT_VERSION).tar.gz
HOST_MENDER_ARTIFACT_LICENSE = Apache2.0, BSD-2-Clause, BSD-3-Clause, ISC, MIT
HOST_MENDER_ARTIFACT_LICENSE_FILES = \
	LICENSE \
	LIC_FILES_CHKSUM.sha256 \
	vendor/github.com/mendersoftware/mendertesting/LICENSE \
	vendor/github.com/pkg/errors/LICENSE \
	vendor/github.com/pmezard/go-difflib/LICENSE \
	vendor/golang.org/x/sys/LICENSE \
	vendor/golang.org/x/crypto/LICENSE \
	vendor/github.com/remyoudompheng/go-liblzma/LICENSE \
	vendor/github.com/davecgh/go-spew/LICENSE \
	vendor/github.com/stretchr/testify/LICENSE \
	vendor/github.com/urfave/cli/LICENSE \
	vendor/github.com/sirupsen/logrus/LICENSE
HOST_MENDER_ARTIFACT_DEPENDENCIES = host-xz

HOST_MENDER_ARTIFACT_LDFLAGS = -X main.Version=$(HOST_MENDER_ARTIFACT_VERSION)

HOST_MENDER_ARTIFACT_BUILD_TARGETS = cli/mender-artifact

HOST_MENDER_ARTIFACT_BIN_NAME = mender-artifact
HOST_MENDER_ARTIFACT_INSTALL_BINS = $(HOST_MENDER_ARTIFACT_BIN_NAME)

$(eval $(host-golang-package))
