#!/usr/bin/env bash
# shellcheck shell=bash

# HackGen font setup shared by host setup scripts.

install_hackgen_for_linux() {
    local version="${HACKGEN_VERSION:?HACKGEN_VERSION must be set}"
    local tmp_dir
    local zip_name="HackGen_NF_v${version}.zip"
    local extract_dir
    local font_dir="${HOME}/.local/share/fonts/HackGen"

    tmp_dir="$(mktemp -d)"
    setup_register_tmp_dir "${tmp_dir}"
    extract_dir="${tmp_dir}/HackGen_NF_v${version}"

    curl -fL \
        -o "${tmp_dir}/${zip_name}" \
        "https://github.com/yuru7/HackGen/releases/download/v${version}/${zip_name}"

    unzip -q "${tmp_dir}/${zip_name}" -d "${tmp_dir}"
    install -d -m 0755 "${font_dir}"
    install -m 0644 \
        "${extract_dir}/HackGen35ConsoleNF-Regular.ttf" \
        "${extract_dir}/HackGen35ConsoleNF-Bold.ttf" \
        "${font_dir}/"
    fc-cache -f "${font_dir}"
    fc-match "HackGen35 Console NF"
}

install_hackgen_for_macos() {
    local version="${HACKGEN_VERSION:?HACKGEN_VERSION must be set}"
    local tmp_dir
    local zip_name="HackGen_NF_v${version}.zip"
    local extract_dir
    local font_dir="${HOME}/Library/Fonts/HackGen"

    tmp_dir="$(mktemp -d)"
    setup_register_tmp_dir "${tmp_dir}"
    extract_dir="${tmp_dir}/HackGen_NF_v${version}"

    curl -fL \
        -o "${tmp_dir}/${zip_name}" \
        "https://github.com/yuru7/HackGen/releases/download/v${version}/${zip_name}"

    unzip -q "${tmp_dir}/${zip_name}" -d "${tmp_dir}"
    install -d -m 0755 "${font_dir}"
    install -m 0644 \
        "${extract_dir}/HackGen35ConsoleNF-Regular.ttf" \
        "${extract_dir}/HackGen35ConsoleNF-Bold.ttf" \
        "${font_dir}/"
}
