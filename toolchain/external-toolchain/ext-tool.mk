#
# copy_toolchain_lib_root
#
# $1: source
# $2: destination
# $2: strip (y|n)	default is to strip
#
copy_toolchain_lib_root =									\
	LIB="$(strip $1)";									\
	DST="$(strip $2)";									\
	STRIP="$(strip $3)";									\
												\
	LIB_DIR=`$(TARGET_CC) -print-file-name=$${LIB} | sed -e "s,/$${LIB}\$$,,"`;		\
												\
	if test -z "$${LIB_DIR}"; then								\
		echo "copy_toolchain_lib_root: lib=$${LIB} not found";				\
		exit -1;									\
	fi;											\
												\
	LIB="$(strip $1)";									\
	for FILE in `find $${LIB_DIR} -maxdepth 1 -type l -name "$${LIB}*"`; do			\
		LIB=`basename $${FILE}`;							\
		while test \! -z "$${LIB}"; do							\
			echo "copy_toolchain_lib_root lib=$${LIB} dst=$${DST}";			\
			rm -fr $(TARGET_DIR)$${DST}/$${LIB};					\
			mkdir -p $(TARGET_DIR)$${DST};						\
			if test -h $${LIB_DIR}/$${LIB}; then					\
				cp -d $${LIB_DIR}/$${LIB} $(TARGET_DIR)$${DST}/;			\
			elif test -f $${LIB_DIR}/$${LIB}; then					\
				cp $${LIB_DIR}/$${LIB} $(TARGET_DIR)$${DST}/$${LIB};	\
				case "$${STRIP}" in						\
				(0 | n | no)							\
					;;							\
				(*)								\
					$(TARGET_CROSS)strip "$(TARGET_DIR)$${DST}/$${LIB}";		\
					;;							\
				esac;								\
			else									\
				exit -1;							\
			fi;									\
			LIB="`readlink $${LIB_DIR}/$${LIB}`";					\
		done;										\
	done;											\
												\
	echo -n

uclibc: dependencies $(TARGET_DIR)/lib/$(strip $(subst ",, $(BR2_TOOLCHAIN_EXTERNAL_LIB_C)))

$(TARGET_DIR)/lib/$(strip $(subst ",, $(BR2_TOOLCHAIN_EXTERNAL_LIB_C))):
#"))
	mkdir -p $(TARGET_DIR)/lib
	@$(call copy_toolchain_lib_root, $(strip $(subst ",, $(BR2_TOOLCHAIN_EXTERNAL_LIB_C))), /lib, $(BR2_TOOLCHAIN_EXTERNAL_STRIP))
#")))
	for libs in $(strip $(subst ",, $(BR2_TOOLCHAIN_EXTERNAL_LIBS))) ; do \
		$(call copy_toolchain_lib_root, $$libs, /lib, $(BR2_TOOLCHAIN_EXTERNAL_STRIP)) ; \
	done
