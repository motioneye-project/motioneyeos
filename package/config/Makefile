obj := .
src := .
top_srcdir=../../
top_builddir=../../
srctree := .

include Makefile.kconfig
#HOSTCFLAGS+=-Dinline="" -include foo.h
-include .depend
.depend: $(wildcard *.h *.c)
	$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) -MM *.c > .depend 2>/dev/null || :

__hostprogs := $(sort $(hostprogs-y) $(hostprogs-m))
host-csingle := $(foreach m,$(__hostprogs),$(if $($(m)-objs),,$(m)))
host-cmulti := $(foreach m,$(__hostprogs),\
           $(if $($(m)-cxxobjs),,$(if $($(m)-objs),$(m))))
host-cxxmulti := $(foreach m,$(__hostprogs),\
           $(if $($(m)-cxxobjs),$(m),$(if $($(m)-objs),)))
host-cobjs := $(sort $(foreach m,$(__hostprogs),$($(m)-objs)))
host-cxxobjs := $(sort $(foreach m,$(__hostprogs),$($(m)-cxxobjs)))

$(host-csingle): %: %.c
	$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCFLAGS_$@) $< $(HOST_LOADLIBES) -o $@

$(host-cmulti): %: $(host-cobjs) $(host-cshlib)
	$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCFLAGS_$@) $($@-objs) $(HOST_LOADLIBES) -o $@

$(host-cxxmulti): %: $(host-cxxobjs) $(host-cobjs) $(host-cshlib)
	$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCFLAGS_$@) $($@-objs) $($@-cxxobjs) $(HOSTLOADLIBES_$@) -o $@

$(host-cobjs): %.o: %.c
	$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCFLAGS_$@) -c $< -o $@

$(host-cxxobjs): %.o: %.cc
	$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCXXFLAGS_$@) -c $< -o $@

$(obj)/%:: $(src)/%_shipped
	$(Q)cat $< > $@

clean:
	$(Q)rm -f $(clean-files)
distclean: clean
	$(Q)rm -f $(lxdialog) $(conf-objs) $(mconf-objs) $(kxgettext-objs) \
		$(hostprogs-y) $(qconf-cxxobjs) $(qconf-objs) $(gconf-objs) \
		mconf .depend
	$(Q)rm -rf buildroot-config

FORCE:
.PHONY: FORCE clean distclean
