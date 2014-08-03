################################################################################
#
# This file contains the download helpers for the various package
# infrastructures. It is used to handle downloads from HTTP servers,
# FTP servers, Git repositories, Subversion repositories, Mercurial
# repositories, Bazaar repositories, and SCP servers.
#
################################################################################

# Download method commands
export WGET := $(call qstrip,$(BR2_WGET)) $(QUIET)
export SVN := $(call qstrip,$(BR2_SVN))
export CVS := $(call qstrip,$(BR2_CVS))
export BZR := $(call qstrip,$(BR2_BZR))
export GIT := $(call qstrip,$(BR2_GIT))
export HG := $(call qstrip,$(BR2_HG)) $(QUIET)
export SCP := $(call qstrip,$(BR2_SCP)) $(QUIET)
SSH := $(call qstrip,$(BR2_SSH)) $(QUIET)
export LOCALFILES := $(call qstrip,$(BR2_LOCALFILES))

# Default spider mode is 'DOWNLOAD'. Other possible values are 'SOURCE_CHECK'
# used by the _source-check target and 'SHOW_EXTERNAL_DEPS', used by the
# external-deps target.
DL_MODE=DOWNLOAD

# DL_DIR may have been set already from the environment
ifeq ($(origin DL_DIR),undefined)
DL_DIR ?= $(call qstrip,$(BR2_DL_DIR))
ifeq ($(DL_DIR),)
DL_DIR := $(TOPDIR)/dl
endif
else
# Restore the BR2_DL_DIR that was overridden by the .config file
BR2_DL_DIR = $(DL_DIR)
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

# github(user,package,version): returns site of GitHub repository
github = https://github.com/$(1)/$(2)/archive/$(3)

# Helper for checking a tarball's checksum
# If the hash does not match, remove the incorrect file
# $(1): the path to the file with the hashes
# $(2): the full path to the file to check
define VERIFY_HASH
	if ! support/download/check-hash $(1) $(2); then \
		rm -f $(2); \
		exit 1; \
	fi
endef

################################################################################
# The DOWNLOAD_* helpers are in charge of getting a working copy
# of the source repository for their corresponding SCM,
# checking out the requested version / commit / tag, and create an
# archive out of it. DOWNLOAD_SCP uses scp to obtain a remote file with
# ssh authentication. DOWNLOAD_WGET is the normal wget-based download
# mechanism.
#
# The SOURCE_CHECK_* helpers are in charge of simply checking that the source
# is available for download. This can be used to make sure one will be able
# to get all the sources needed for one's build configuration.
#
# The SHOW_EXTERNAL_DEPS_* helpers simply output to the console the names
# of the files that will be downloaded, or path and revision of the
# source repositories, producing a list of all the "external dependencies"
# of a given build configuration.
################################################################################

# Try a shallow clone - but that only works if the version is a ref (tag or
# branch). Before trying to do a shallow clone we check if $($(PKG)_DL_VERSION)
# is in the list provided by git ls-remote. If not we fall back on a full clone.
#
# Messages for the type of clone used are provided to ease debugging in case of
# problems
define DOWNLOAD_GIT
	test -e $(DL_DIR)/$($(PKG)_SOURCE) || \
	$(EXTRA_ENV) support/download/wrapper git \
		$(DL_DIR)/$($(PKG)_SOURCE) \
		$($(PKG)_SITE) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_BASE_NAME)
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
	$(EXTRA_ENV) support/download/wrapper bzr \
		$(DL_DIR)/$($(PKG)_SOURCE) \
		$($(PKG)_SITE) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_BASE_NAME)
endef

define SOURCE_CHECK_BZR
	$(BZR) ls --quiet $($(PKG)_SITE) > /dev/null
endef

define SHOW_EXTERNAL_DEPS_BZR
	echo $($(PKG)_SOURCE)
endef

define DOWNLOAD_CVS
	test -e $(DL_DIR)/$($(PKG)_SOURCE) || \
	$(EXTRA_ENV) support/download/wrapper cvs \
		$(DL_DIR)/$($(PKG)_SOURCE) \
		$(call stripurischeme,$(call qstrip,$($(PKG)_SITE))) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_RAWNAME) \
		$($(PKG)_BASE_NAME)
endef

# Not all CVS servers support ls/rls, use login to see if we can connect
define SOURCE_CHECK_CVS
	$(CVS) -d:pserver:anonymous:@$(call stripurischeme,$(call qstrip,$($(PKG)_SITE))) login
endef

define SHOW_EXTERNAL_DEPS_CVS
	echo $($(PKG)_SOURCE)
endef

define DOWNLOAD_SVN
	test -e $(DL_DIR)/$($(PKG)_SOURCE) || \
	$(EXTRA_ENV) support/download/wrapper svn \
		$(DL_DIR)/$($(PKG)_SOURCE) \
		$($(PKG)_SITE) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_BASE_NAME)
endef

define SOURCE_CHECK_SVN
  $(SVN) ls $($(PKG)_SITE)@$($(PKG)_DL_VERSION) > /dev/null
endef

define SHOW_EXTERNAL_DEPS_SVN
  echo $($(PKG)_SOURCE)
endef

# SCP URIs should be of the form scp://[user@]host:filepath
# Note that filepath is relative to the user's home directory, so you may want
# to prepend the path with a slash: scp://[user@]host:/absolutepath
define DOWNLOAD_SCP
	test -e $(DL_DIR)/$(2) || \
	$(EXTRA_ENV) support/download/wrapper scp \
		$(DL_DIR)/$(2) \
		'$(call stripurischeme,$(call qstrip,$(1)))' && \
	$(call VERIFY_HASH,$(PKGDIR)/$($(PKG)_NAME).hash,$(DL_DIR)/$(2))
endef

define SOURCE_CHECK_SCP
	$(SSH) $(call domain,$(1),:) ls '$(call notdomain,$(1),:)' > /dev/null
endef

define SHOW_EXTERNAL_DEPS_SCP
	echo $(2)
endef


define DOWNLOAD_HG
	test -e $(DL_DIR)/$($(PKG)_SOURCE) || \
	$(EXTRA_ENV) support/download/wrapper hg \
		$(DL_DIR)/$($(PKG)_SOURCE) \
		$($(PKG)_SITE) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_BASE_NAME)
endef

# TODO: improve to check that the given PKG_DL_VERSION exists on the remote
# repository
define SOURCE_CHECK_HG
  $(HG) incoming --force -l1 $($(PKG)_SITE) > /dev/null
endef

define SHOW_EXTERNAL_DEPS_HG
  echo $($(PKG)_SOURCE)
endef


define DOWNLOAD_WGET
	test -e $(DL_DIR)/$(2) || \
	$(EXTRA_ENV) support/download/wrapper wget \
		$(DL_DIR)/$(2) \
		'$(call qstrip,$(1))' && \
	$(call VERIFY_HASH,$(PKGDIR)/$($(PKG)_NAME).hash,$(DL_DIR)/$(2))
endef

define SOURCE_CHECK_WGET
  $(WGET) --spider '$(call qstrip,$(1))'
endef

define SHOW_EXTERNAL_DEPS_WGET
  echo $(2)
endef

define DOWNLOAD_LOCALFILES
	test -e $(DL_DIR)/$(2) || \
	$(EXTRA_ENV) support/download/wrapper cp \
		$(DL_DIR)/$(2) \
		$(call stripurischeme,$(call qstrip,$(1))) && \
	$(call VERIFY_HASH,$(PKGDIR)/$($(PKG)_NAME).hash,$(DL_DIR)/$(2))
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
#
# E.G. use like this:
# $(call DOWNLOAD,$(FOO_SITE))
################################################################################

define DOWNLOAD
	$(call DOWNLOAD_INNER,$(1),$(notdir $(1)))
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
			cvs) $($(DL_MODE)_CVS) && exit ;; \
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
