################################################################################
#
# This file contains the download helpers for the various package
# infrastructures. It is used to handle downloads from HTTP servers,
# FTP servers, Git repositories, Subversion repositories, Mercurial
# repositories, Bazaar repositories, and SCP servers.
#
################################################################################

# Download method commands
WGET := $(call qstrip,$(BR2_WGET)) $(QUIET)
SVN := $(call qstrip,$(BR2_SVN))
BZR := $(call qstrip,$(BR2_BZR))
GIT := $(call qstrip,$(BR2_GIT))
HG := $(call qstrip,$(BR2_HG)) $(QUIET)
SCP := $(call qstrip,$(BR2_SCP)) $(QUIET)
SSH := $(call qstrip,$(BR2_SSH)) $(QUIET)
LOCALFILES := $(call qstrip,$(BR2_LOCALFILES))

# Default spider mode is 'DOWNLOAD'. Other possible values are 'SOURCE_CHECK'
# used by the _source-check target and 'SHOW_EXTERNAL_DEPS', used by the
# external-deps target.
DL_MODE=DOWNLOAD

# Override BR2_DL_DIR if shell variable defined
ifneq ($(BUILDROOT_DL_DIR),)
DL_DIR := $(BUILDROOT_DL_DIR)
else
DL_DIR := $(call qstrip,$(BR2_DL_DIR))
endif

ifeq ($(DL_DIR),)
DL_DIR := $(TOPDIR)/dl
endif

# ensure it exists and a absolute path
DL_DIR := $(shell mkdir -p $(DL_DIR) && cd $(DL_DIR) >/dev/null && pwd)

#
# URI scheme helper functions
# Example URIs:
# * http://www.example.com/dir/file
# * scp://www.example.com:dir/file (with domainseparator :)
#
# geturischeme: http
geturischeme=$(firstword $(subst ://, ,$(call qstrip,$(1))))
# stripurischeme: www.example.com/dir/file
stripurischeme=$(lastword $(subst ://, ,$(call qstrip,$(1))))
# domain: www.example.com
domain=$(firstword $(subst $(call domainseparator,$(2)), ,$(call stripurischeme,$(1))))
# notdomain: dir/file
notdomain=$(patsubst $(call domain,$(1),$(2))$(call domainseparator,$(2))%,%,$(call stripurischeme,$(1)))
#
# default domainseparator is /, specify alternative value as first argument
domainseparator=$(if $(1),$(1),/)

################################################################################
# The DOWNLOAD_{GIT,SVN,BZR,HG,LOCALFILES} helpers are in charge of getting a
# working copy of the source repository for their corresponding SCM,
# checking out the requested version / commit / tag, and create an
# archive out of it. DOWNLOAD_SCP uses scp to obtain a remote file with
# ssh authentication. DOWNLOAD_WGET is the normal wget-based download
# mechanism.
#
# The SOURCE_CHECK_{GIT,SVN,BZR,HG,WGET,LOCALFILES,SCP} helpers are in charge of
# simply checking that the source is available for download. This can be used
# to make sure one will be able to get all the sources needed for
# one's build configuration.
#
# The SHOW_EXTERNAL_DEPS_{GIT,SVN,BZR,HG,WGET,LOCALFILES,SCP} helpers simply
# output to the console the names of the files that will be downloaded, or path
# and revision of the source repositories, producing a list of all the
# "external dependencies" of a given build configuration.
################################################################################

# Try a shallow clone - but that only works if the version is a ref (tag or
# branch). Before trying to do a shallow clone we check if $($(PKG)_DL_VERSION)
# is in the list provided by git ls-remote. If not we fall back on a full clone.
#
# Messages for the type of clone used are provided to ease debugging in case of
# problems
define DOWNLOAD_GIT
	test -e $(DL_DIR)/$($(PKG)_SOURCE) || \
	(pushd $(DL_DIR) > /dev/null && \
	 ((test "`git ls-remote $($(PKG)_SITE) $($(PKG)_DL_VERSION)`" && \
	   echo "Doing shallow clone" && \
	   $(GIT) clone --depth 1 -b $($(PKG)_DL_VERSION) --bare $($(PKG)_SITE) $($(PKG)_BASE_NAME)) || \
	  (echo "Doing full clone" && \
	   $(GIT) clone --bare $($(PKG)_SITE) $($(PKG)_BASE_NAME))) && \
	pushd $($(PKG)_BASE_NAME) > /dev/null && \
	$(GIT) archive --format=tar --prefix=$($(PKG)_BASE_NAME)/ $($(PKG)_DL_VERSION) | \
		gzip -c > $(DL_DIR)/$($(PKG)_SOURCE) && \
	popd > /dev/null && \
	rm -rf $($(PKG)_DL_DIR) && \
	popd > /dev/null)
endef

# TODO: improve to check that the given PKG_DL_VERSION exists on the remote
# repository
define SOURCE_CHECK_GIT
  $(GIT) ls-remote --heads $($(PKG)_SITE) > /dev/null
endef

define SHOW_EXTERNAL_DEPS_GIT
	echo $($(PKG)_SOURCE)
endef


define DOWNLOAD_BZR
	test -e $(DL_DIR)/$($(PKG)_SOURCE) || \
	$(BZR) export $(DL_DIR)/$($(PKG)_SOURCE) $($(PKG)_SITE) -r $($(PKG)_DL_VERSION)
endef

define SOURCE_CHECK_BZR
	$(BZR) ls --quiet $($(PKG)_SITE) > /dev/null
endef

define SHOW_EXTERNAL_DEPS_BZR
	echo $($(PKG)_SOURCE)
endef


define DOWNLOAD_SVN
	test -e $(DL_DIR)/$($(PKG)_SOURCE) || \
	(pushd $(DL_DIR) > /dev/null && \
	$(SVN) export -r $($(PKG)_DL_VERSION) $($(PKG)_SITE) $($(PKG)_DL_DIR) && \
	$(TAR) czf $($(PKG)_SOURCE) $($(PKG)_BASE_NAME)/ && \
	rm -rf $($(PKG)_DL_DIR) && \
	popd > /dev/null)
endef

define SOURCE_CHECK_SVN
  $(SVN) ls $($(PKG)_SITE) > /dev/null
endef

define SHOW_EXTERNAL_DEPS_SVN
  echo $($(PKG)_SOURCE)
endef

# SCP URIs should be of the form scp://[user@]host:filepath
# Note that filepath is relative to the user's home directory, so you may want
# to prepend the path with a slash: scp://[user@]host:/absolutepath
define DOWNLOAD_SCP
	test -e $(DL_DIR)/$(2) || \
	$(SCP) '$(call stripurischeme,$(call qstrip,$(1)))' $(DL_DIR)/$(2)
endef

define SOURCE_CHECK_SCP
	$(SSH) $(call domain,$(1),:) ls '$(call notdomain,$(1),:)' > /dev/null
endef

define SHOW_EXTERNAL_DEPS_SCP
	echo $(2)
endef


define DOWNLOAD_HG
	test -e $(DL_DIR)/$($(PKG)_SOURCE) || \
	(pushd $(DL_DIR) > /dev/null && \
	$(HG) clone --noupdate --rev $($(PKG)_DL_VERSION) $($(PKG)_SITE) $($(PKG)_BASE_NAME) && \
	$(HG) archive --repository $($(PKG)_BASE_NAME) --type tgz --prefix $($(PKG)_BASE_NAME)/ \
	              --rev $($(PKG)_DL_VERSION) $(DL_DIR)/$($(PKG)_SOURCE) && \
	rm -rf $($(PKG)_DL_DIR) && \
	popd > /dev/null)
endef

# TODO: improve to check that the given PKG_DL_VERSION exists on the remote
# repository
define SOURCE_CHECK_HG
  $(HG) incoming --force -l1 $($(PKG)_SITE) > /dev/null
endef

define SHOW_EXTERNAL_DEPS_HG
  echo $($(PKG)_SOURCE)
endef

# Download a file using wget. Only download the file if it doesn't
# already exist in the download directory. If the download fails,
# remove the file (because wget -O creates a 0-byte file even if the
# download fails).  To handle an interrupted download as well, download
# to a temporary file first.  The temporary file will be overwritten
# the next time the download is tried.
define DOWNLOAD_WGET
	test -e $(DL_DIR)/$(2) || \
	($(WGET) -O $(DL_DIR)/$(2).tmp '$(call qstrip,$(1))' && \
	 mv $(DL_DIR)/$(2).tmp $(DL_DIR)/$(2)) || \
	(rm -f $(DL_DIR)/$(2).tmp ; exit 1)
endef

define SOURCE_CHECK_WGET
  $(WGET) --spider '$(call qstrip,$(1))'
endef

define SHOW_EXTERNAL_DEPS_WGET
  echo $(2)
endef

define DOWNLOAD_LOCALFILES
	test -e $(DL_DIR)/$(2) || \
		$(LOCALFILES) $(call stripurischeme,$(call qstrip,$(1))) $(DL_DIR)
endef

define SOURCE_CHECK_LOCALFILES
  test -e $(call stripurischeme,$(call qstrip,$(1)))
endef

define SHOW_EXTERNAL_DEPS_LOCALFILES
  echo $(2)
endef

################################################################################
# DOWNLOAD -- Download helper. Will try to download source from:
# 1) BR2_PRIMARY_SITE if enabled
# 2) Download site, unless BR2_PRIMARY_SITE_ONLY is set
# 3) BR2_BACKUP_SITE if enabled, unless BR2_PRIMARY_SITE_ONLY is set
#
# Argument 1 is the source location
# Argument 2 is the source filename
#
# E.G. use like this:
# $(call DOWNLOAD,$(FOO_SITE),$(FOO_SOURCE))
################################################################################

define DOWNLOAD
	$(call DOWNLOAD_INNER,$(1),$(if $(2),$(2),$(notdir $(1))))
endef

define DOWNLOAD_INNER
	$(Q)if test -n "$(call qstrip,$(BR2_PRIMARY_SITE))" ; then \
		case "$(call geturischeme,$(BR2_PRIMARY_SITE))" in \
			scp) $(call $(DL_MODE)_SCP,$(BR2_PRIMARY_SITE)/$(2),$(2)) && exit ;; \
			*) $(call $(DL_MODE)_WGET,$(BR2_PRIMARY_SITE)/$(2),$(2)) && exit ;; \
		esac ; \
	fi ; \
	if test "$(BR2_PRIMARY_SITE_ONLY)" = "y" ; then \
		exit 1 ; \
	fi ; \
	if test -n "$(1)" ; then \
		if test -z "$($(PKG)_SITE_METHOD)" ; then \
			scheme="$(call geturischeme,$(1))" ; \
		else \
			scheme="$($(PKG)_SITE_METHOD)" ; \
		fi ; \
		case "$$scheme" in \
			git) $($(DL_MODE)_GIT) && exit ;; \
			svn) $($(DL_MODE)_SVN) && exit ;; \
			bzr) $($(DL_MODE)_BZR) && exit ;; \
			file) $($(DL_MODE)_LOCALFILES) && exit ;; \
			scp) $($(DL_MODE)_SCP) && exit ;; \
			hg) $($(DL_MODE)_HG) && exit ;; \
			*) $(call $(DL_MODE)_WGET,$(1),$(2)) && exit ;; \
		esac ; \
	fi ; \
	if test -n "$(call qstrip,$(BR2_BACKUP_SITE))" ; then \
		$(call $(DL_MODE)_WGET,$(BR2_BACKUP_SITE)/$(2),$(2)) && exit ; \
	fi ; \
	exit 1
endef
