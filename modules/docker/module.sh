#!/usr/bin/env bash
# shellcheck shell=bash

# Docker Engine setup for Ubuntu hosts.

remove_conflicting_docker_packages_for_ubuntu() {
    local conflicting_packages=(
        docker.io
        docker-compose
        docker-compose-v2
        docker-doc
        podman-docker
        containerd
        runc
    )
    local installed_packages=()
    local package

    for package in "${conflicting_packages[@]}"; do
        if dpkg-query -W -f='${Status}' "${package}" 2>/dev/null | grep -q '^install ok installed$'; then
            installed_packages+=("${package}")
        fi
    done

    if ((${#installed_packages[@]} > 0)); then
        as_root apt-get remove -y "${installed_packages[@]}"
    fi
}

module_install() {
    [[ "${OS}" == "ubuntu" ]] || unsupported_os

    local ubuntu_codename
    local architecture
    local target_user

    remove_conflicting_docker_packages_for_ubuntu

    # shellcheck source=/dev/null
    . /etc/os-release
    ubuntu_codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
    if [[ -z "${ubuntu_codename}" ]]; then
        echo "Error: Ubuntu codename was not found in /etc/os-release." >&2
        return 1
    fi

    architecture="$(dpkg --print-architecture)"

    as_root install -m 0755 -d /etc/apt/keyrings
    as_root curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    as_root chmod a+r /etc/apt/keyrings/docker.asc

    as_root tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${ubuntu_codename}
Components: stable
Architectures: ${architecture}
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    as_root apt-get update -y
    as_root apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

    if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files docker.service >/dev/null 2>&1; then
        as_root systemctl start docker
    fi

    if [[ "${DOCKER_ADD_USER_TO_GROUP:-false}" == "true" ]]; then
        target_user="${USER:-$(id -un)}"
        as_root groupadd -f docker
        as_root usermod -aG docker "${target_user}"
        echo "Docker group updated for ${target_user}. Log out and back in before running docker without sudo."
    else
        target_user="${USER:-$(id -un)}"
        echo "Docker installed. Use sudo for docker commands, or rerun with DOCKER_ADD_USER_TO_GROUP=true to add ${target_user} to the docker group."
    fi
}
