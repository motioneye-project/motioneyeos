LTTNG_BABELTRACE_SITE    = http://lttng.org/files/bundles/20111214/
LTTNG_BABELTRACE_VERSION = 0.8
LTTNG_BABELTRACE_SOURCE  = babeltrace-$(LTTNG_BABELTRACE_VERSION).tar.bz2

# Needed to fix libtool handling, otherwise the build fails when
# building the ctf-parser-test program, which depends on libctf-ast.so
# which itself depends on libbabeltrace_types.so.0 (and libtool gets
# lost in the middle of this).
LTTNG_BABELTRACE_AUTORECONF      = YES
HOST_LTTNG_BABELTRACE_AUTORECONF = YES

LTTNG_BABELTRACE_DEPENDENCIES = popt util-linux libglib2

$(eval $(autotools-package))
$(eval $(host-autotools-package))
