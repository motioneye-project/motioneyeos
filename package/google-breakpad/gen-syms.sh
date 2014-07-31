#!/bin/sh
NAME="${0##*/}"
STAGING_DIR="${1}"
TARGET_DIR="${2}"
shift 2

SYMBOLS_DIR="${STAGING_DIR}/usr/share/google-breakpad-symbols"
rm -rf "${SYMBOLS_DIR}"
mkdir -p "${SYMBOLS_DIR}"

error() {
    fmt="${1}"; shift
    printf "%s: ${fmt}" "${NAME}" "${@}" >&2
    exit 1
}

for FILE in ${@}; do
    f="${TARGET_DIR}${FILE}"
    if [ ! -e "${f}" ]; then
        error "%s: No such file or directory\n" "${FILE}"
    fi
	if [ -d "${f}" ]; then
		error "%s: Is a directory\n" "${FILE}"
	fi
	if dump_syms "${f}" > "${SYMBOLS_DIR}/tmp.sym" 2>/dev/null; then
		hash=$(head -n1 "${SYMBOLS_DIR}/tmp.sym" | cut -d ' ' -f 4);
		filename=$(basename "${FILE}");
		mkdir -p "${SYMBOLS_DIR}/${filename}/${hash}"
		mv "${SYMBOLS_DIR}/tmp.sym" "${SYMBOLS_DIR}/${filename}/${hash}/${filename}.sym";
	else
		error "Error dumping symbols for: '%s'\n" "${FILE}"
	fi
done
rm -rf "${SYMBOLS_DIR}/tmp"
