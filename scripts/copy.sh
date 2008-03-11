#!/bin/sh

STAGING_DIR=$1
TARGET_DIR=$2

echo "Copying development files to target..."

cp -a ${STAGING_DIR}/usr/include ${TARGET_DIR}/usr

for LIBSDIR in /lib /usr/lib; do
	for WILDCARD in *.a *.la; do
		for FILE_PATH in `find ${STAGING_DIR}${LIBSDIR} -name ${WILDCARD}`; do
			STAGING_STRIPPED=${FILE_PATH##${STAGING_DIR}}
			EXTENDED_DIR=${STAGING_STRIPPED%/${WILDCARD}}
			mkdir -p ${TARGET_DIR}${EXTENDED_DIR}
			cp ${FILE_PATH} ${TARGET_DIR}${STAGING_STRIPPED}
			#echo ${TARGET_DIR}${STAGING_STRIPPED}
		done
	done
done
