#############################################################
#
# speech-tools
#
#############################################################
SPEECH_TOOLS_VERSION = 1.2.96-beta
SPEECH_TOOLS_SOURCE = speech_tools-$(SPEECH_TOOLS_VERSION).tar.gz
SPEECH_TOOLS_SITE = http://festvox.org/packed/festival/latest
SPEECH_TOOLS_AUTORECONF = NO
SPEECH_TOOLS_INSTALL_STAGING = NO
SPEECH_TOOLS_INSTALL_TARGET = YES
SPEECH_TOOLS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) STRIP=$(TARGET_STRIP) install

SPEECH_TOOLS_CONF_OPT = 
SPEECH_TOOLS_MAKE_OPT = CC=$(TARGET_CC) CXX=$(TARGET_CXX)

SPEECH_TOOLS_DEPENDENCIES = uclibc ncurses

$(eval $(call AUTOTARGETS,package/festival,speech-tools))

