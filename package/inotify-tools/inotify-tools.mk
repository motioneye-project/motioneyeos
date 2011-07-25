#############################################################
#
# inotify-utils
#
#############################################################
INOTIFY_TOOLS_VERSION = 3.14
INOTIFY_TOOLS_SITE = http://github.com/downloads/rvoicilas/inotify-tools/
$(eval $(call AUTOTARGETS,package,inotify-tools))
