################################################################################
#
# qt5script
#
################################################################################

QT5SCRIPT_VERSION = $(QT5_VERSION)
QT5SCRIPT_SITE = $(QT5_SITE)
QT5SCRIPT_SOURCE = qtscript-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5SCRIPT_VERSION).tar.xz
QT5SCRIPT_INSTALL_STAGING = YES

# JavaScriptCore contains files under BSD-2-Clause, BSD-3-Clause, and LGPL-2+.
# This is linked into libQt5Script, which also contains Qt sources under
# LGPL-2.1 (only). Therefore, the library is  LGPL-2.1 and BSD-3-Clause.
# libQt5ScriptTools is under the normal Qt opensource license.
QT5SCRIPT_LICENSE = LGPL-2.1, BSD-3-Clause, LGPL-3.0 or GPL-2.0+ (libQt5ScriptTools), GFDL-1.3 (docs)
# LGPL-2.1 license file is missing
QT5SCRIPT_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.LGPL3 LICENSE.FDL
# License files from JavaScriptCore
QT5SCRIPT_LICENSE_FILES += \
	src/3rdparty/javascriptcore/JavaScriptCore/COPYING.LIB \
	src/3rdparty/javascriptcore/JavaScriptCore/pcre/COPYING

$(eval $(qmake-package))
