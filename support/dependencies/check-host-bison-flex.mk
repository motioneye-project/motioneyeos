# If the system lacks bison or flex, add
# dependencies to suitable host packages

ifeq ($(shell which bison 2>/dev/null),)
BR2_BISON_HOST_DEPENDENCY = host-bison
endif

ifeq ($(shell which flex 2>/dev/null),)
BR2_FLEX_HOST_DEPENDENCY = host-flex
endif
