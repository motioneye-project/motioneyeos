# Check whether the host's coreutils are up to date enough
# to provide 'ln --relative' and 'realpath'.

ifeq (,$(call suitable-host-package,coreutils))
BR2_COREUTILS_HOST_DEPENDENCY = host-coreutils
endif
