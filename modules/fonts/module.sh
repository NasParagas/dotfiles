#!/usr/bin/env bash
# shellcheck shell=bash

HACKGEN_VERSION="2.10.0"

install_module_extras() {
    local font_root
    local font_dir
    local zip_name="HackGen_NF_v${HACKGEN_VERSION}.zip"
    local extract_dir

    case "${OS}" in
        darwin) font_root="${HOME}/Library/Fonts" ;;
        ubuntu) font_root="${HOME}/.local/share/fonts" ;;
        *) die_unsupported_os ;;
    esac
    font_dir="${font_root}/HackGen"

    if [[ -f "${font_root}/HackGen35ConsoleNF-Regular.ttf" || -f "${font_dir}/HackGen35ConsoleNF-Regular.ttf" ]]; then
        return 0
    fi

    make_tmp_dir
    extract_dir="${TMP_DIR}/HackGen_NF_v${HACKGEN_VERSION}"

    curl -fL \
        -o "${TMP_DIR}/${zip_name}" \
        "https://github.com/yuru7/HackGen/releases/download/v${HACKGEN_VERSION}/${zip_name}"

    unzip -q "${TMP_DIR}/${zip_name}" -d "${TMP_DIR}"
    install -d -m 0755 "${font_dir}"
    install -m 0644 \
        "${extract_dir}/HackGen35ConsoleNF-Regular.ttf" \
        "${extract_dir}/HackGen35ConsoleNF-Bold.ttf" \
        "${font_dir}/"

    if have fc-cache; then
        fc-cache -f "${font_dir}"
    fi
}
