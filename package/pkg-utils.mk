############################################################################
#
# This file contains various utility functions used by the package
# infrastructure, or by the packages themselves.
#
############################################################################

# UPPERCASE Macro -- transform its argument to uppercase and replace dots and
# hyphens to underscores

# Heavily inspired by the up macro from gmsl (http://gmsl.sf.net)
# This is approx 5 times faster than forking a shell and tr, and
# as this macro is used a lot it matters
# This works by creating translation character pairs (E.G. a:A b:B)
# and then looping though all of them running $(subst from,to,text)
[FROM] := a b c d e f g h i j k l m n o p q r s t u v w x y z . -
[TO]   := A B C D E F G H I J K L M N O P Q R S T U V W X Y Z _ _

UPPERCASE = $(strip $(eval __tmp := $1) \
     $(foreach c, $(join $(addsuffix :,$([FROM])),$([TO])), \
	$(eval __tmp :=	\
		$(subst $(word 1,$(subst :, ,$c)),$(word 2,$(subst :, ,$c)),\
			$(__tmp)))) \
     $(__tmp))

#
# Manipulation of .config files based on the Kconfig
# infrastructure. Used by the Busybox package, the Linux kernel
# package, and more.
#

define KCONFIG_ENABLE_OPT
       $(SED) "/\\<$(1)\\>/d" $(2)
       echo "$(1)=y" >> $(2)
endef

define KCONFIG_SET_OPT
       $(SED) "/\\<$(1)\\>/d" $(3)
       echo "$(1)=$(2)" >> $(3)
endef

define KCONFIG_DISABLE_OPT
       $(SED) "/\\<$(1)\\>/d" $(2)
       echo "# $(1) is not set" >> $(2)
endef

# Helper functions to determine the name of a package and its
# directory from its makefile directory, using the $(MAKEFILE_LIST)
# variable provided by make. This is used by the *TARGETS macros to
# automagically find where the package is located. Note that the
# pkgdir macro is carefully written to handle the case of the Linux
# package, for which the package directory is an empty string.
define pkgdir
$(dir $(lastword $(MAKEFILE_LIST)))
endef

define pkgname
$(lastword $(subst /, ,$(call pkgdir)))
endef

define pkgparentdir
$(patsubst %$(call pkgname)/,%,$(call pkgdir))
endef

# Define extractors for different archive suffixes
INFLATE.bz2  = $(BZCAT)
INFLATE.gz   = $(ZCAT)
INFLATE.tbz  = $(BZCAT)
INFLATE.tbz2 = $(BZCAT)
INFLATE.tgz  = $(ZCAT)
INFLATE.xz   = $(XZCAT)
INFLATE.tar  = cat

# MESSAGE Macro -- display a message in bold type
MESSAGE = echo "$(TERM_BOLD)>>> $($(PKG)_NAME) $($(PKG)_VERSION) $(1)$(TERM_RESET)"
TERM_BOLD := $(shell tput smso)
TERM_RESET := $(shell tput rmso)


# Needed for the foreach loops to loop over the list of hooks, so that
# each hook call is properly separated by a newline.
define sep


endef
