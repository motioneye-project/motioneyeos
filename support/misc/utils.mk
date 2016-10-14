################################################################################
#
# This file contains various utility macros and variables used about
# everywhere in make constructs.
#
################################################################################

# Strip quotes and then whitespaces
qstrip = $(strip $(subst ",,$(1)))
#"))

# Variables for use in Make constructs
comma := ,
empty :=
space := $(empty) $(empty)

# Case conversion macros. This is inspired by the 'up' macro from gmsl
# (http://gmsl.sf.net). It is optimised very heavily because these macros
# are used a lot. It is about 5 times faster than forking a shell and tr.
#
# The caseconvert-helper creates a definition of the case conversion macro.
# After expansion by the outer $(eval ), the UPPERCASE macro is defined as:
# $(strip $(eval __tmp := $(1))  $(eval __tmp := $(subst a,A,$(__tmp))) ... )
# In other words, every letter is substituted one by one.
#
# The caseconvert-helper allows us to create this definition out of the
# [FROM] and [TO] lists, so we don't need to write down every substition
# manually. The uses of $ and $$ quoting are chosen in order to do as
# much expansion as possible up-front.
#
# Note that it would be possible to conceive a slightly more optimal
# implementation that avoids the use of __tmp, but that would be even
# more unreadable and is not worth the effort.

[FROM] := a b c d e f g h i j k l m n o p q r s t u v w x y z - .
[TO]   := A B C D E F G H I J K L M N O P Q R S T U V W X Y Z _ _

define caseconvert-helper
$(1) = $$(strip \
	$$(eval __tmp := $$(1))\
	$(foreach c, $(2),\
		$$(eval __tmp := $$(subst $(word 1,$(subst :, ,$c)),$(word 2,$(subst :, ,$c)),$$(__tmp))))\
	$$(__tmp))
endef

$(eval $(call caseconvert-helper,UPPERCASE,$(join $(addsuffix :,$([FROM])),$([TO]))))
$(eval $(call caseconvert-helper,LOWERCASE,$(join $(addsuffix :,$([TO])),$([FROM]))))

# Reverse the orders of words in a list. Again, inspired by the gmsl
# 'reverse' macro.
reverse = $(if $(1),$(call reverse,$(wordlist 2,$(words $(1)),$(1))) $(firstword $(1)))

# Sanitize macro cleans up generic strings so it can be used as a filename
# and in rules. Particularly useful for VCS version strings, that can contain
# slashes, colons (OK in filenames but not in rules), and spaces.
sanitize = $(subst $(space),_,$(subst :,_,$(subst /,_,$(strip $(1)))))

# MESSAGE Macro -- display a message in bold type
MESSAGE = echo "$(TERM_BOLD)>>> $($(PKG)_NAME) $($(PKG)_VERSION) $(call qstrip,$(1))$(TERM_RESET)"
TERM_BOLD := $(shell tput smso 2>/dev/null)
TERM_RESET := $(shell tput rmso 2>/dev/null)

# Utility functions for 'find'
# findfileclauses(filelist) => -name 'X' -o -name 'Y'
findfileclauses = $(call notfirstword,$(patsubst %,-o -name '%',$(1)))
# finddirclauses(base, dirlist) => -path 'base/dirX' -o -path 'base/dirY'
finddirclauses = $(call notfirstword,$(patsubst %,-o -path '$(1)/%',$(2)))

# Miscellaneous utility functions
# notfirstword(wordlist): returns all but the first word in wordlist
notfirstword = $(wordlist 2,$(words $(1)),$(1))

# Needed for the foreach loops to loop over the list of hooks, so that
# each hook call is properly separated by a newline.
define sep


endef

PERCENT = %
QUOTE = '
# ' # Meh... syntax-highlighting

# This macro properly escapes a command string, then prints it with printf:
#
#   - first, backslash '\' are self-escaped, so that they do not escape
#     the following char and so that printf properly outputs a backslash;
#
#   - next, single quotes are escaped by closing an existing one, adding
#     an escaped one, and re-openning a new one (see below for the reason);
#
#   - then '%' signs are self-escaped so that the printf does not interpret
#     them as a format specifier, in case the variable contains an actual
#     printf with a format;
#
#   - finally, $(sep) is replaced with the literal '\n' so that make does
#     not break on the so-expanded variable, but so that the printf does
#     correctly output an LF.
#
# Note: this must be escaped in this order to avoid over-escaping the
# previously escaped elements.
#
# Once everything has been escaped, it is passed between single quotes
# (that's why the single-quotes are escaped they way they are, above,
# and why the dollar sign is not escaped) to printf(1). A trailing
# newline is apended, too.
#
# Note: leading or trailing spaces are *not* stripped.
#
define PRINTF
	printf '$(subst $(sep),\n,\
		$(subst $(PERCENT),$(PERCENT)$(PERCENT),\
			$(subst $(QUOTE),$(QUOTE)\$(QUOTE)$(QUOTE),\
				$(subst \,\\,$(1)))))\n'
endef
