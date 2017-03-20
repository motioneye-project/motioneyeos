#!/bin/sh
(
printf "arg1,%s\n" "${1}"
printf "arg2,%s\n" "${2}"
printf "arg3,%s\n" "${3}"
printf "TARGET_DIR,%s\n" "${TARGET_DIR}"
printf "BUILD_DIR,%s\n" "${BUILD_DIR}"
printf "HOST_DIR,%s\n" "${HOST_DIR}"
printf "STAGING_DIR,%s\n" "${STAGING_DIR}"
printf "BINARIES_DIR,%s\n" "${BINARIES_DIR}"
printf "BR2_CONFIG,%s\n" "${BR2_CONFIG}"
) > ${BUILD_DIR}/post-build.log
