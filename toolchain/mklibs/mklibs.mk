######################################################################
#
# mklibs
#
######################################################################
MKLIBS_PROGRAM:=$(STAGING_DIR)/bin/mklibs.py

$(MKLIBS_PROGRAM): toolchain/mklibs/mklibs.py
	cp -a toolchain/mklibs/mklibs.py $@

mklibs-clean:
	rm -f $(MKLIBS_PROGRAM)

mklibs-dirclean:
	true

#############################################################
#
# Run mklibs
#
#############################################################
MKLIBS_PYTHON:=$(shell which python)
ifeq ($(MKLIBS_PYTHON),)
    MKLIBS_PYTHON=/usr/bin/python
endif

$(STAGING_DIR)/mklibs-stamp: $(MKLIBS_PROGRAM) $(MKLIBS_PYTHON) $(STAGING_DIR)/lib/*
	find $(TARGET_DIR) -type f -perm +100 -exec \
	    file -r -N -F '' {} + | \
	    awk ' /executable.*dynamically/ { print $$1 }' > $(STAGING_DIR)/mklibs-progs
	cd $(TARGET_DIR); PATH=$(PATH):$(STAGING_DIR)/bin $(MKLIBS_PYTHON) $(MKLIBS_PROGRAM) \
	    --target $(REAL_GNU_TARGET_NAME) --root $(STAGING_DIR) -d ./ \
	    `cat $(STAGING_DIR)/mklibs-progs`
	touch $@

# this empty target allows a mklibs dependeny to be included in the
# target targets, but it will be only invoked if BR2_MKLIBS is conf'ed
.PHONY: mklibs
mklibs:

#############################################################
#
# Toplevel Makefile options
#
#############################################################

ifeq ($(strip $(BR2_MKLIBS)),y)
mklibs: $(STAGING_DIR)/mklibs-stamp
endif
