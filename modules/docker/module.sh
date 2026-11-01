#!/usr/bin/env bash
# shellcheck shell=bash

# Ubuntu ホストに Docker Engine を導入する

remove_conflicting_docker_packages() {
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
        run_as_root apt-get remove -y "${installed_packages[@]}"
    fi
}

add_docker_apt_repository() {
    local ubuntu_codename
    local architecture

    # shellcheck source=/dev/null
    . /etc/os-release
    ubuntu_codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
    [[ -n "${ubuntu_codename}" ]] || die "Ubuntu codename was not found in /etc/os-release."

    architecture="$(dpkg --print-architecture)"

    run_as_root install -m 0755 -d /etc/apt/keyrings
    run_as_root curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    run_as_root chmod a+r /etc/apt/keyrings/docker.asc

    run_as_root tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${ubuntu_codename}
Components: stable
Architectures: ${architecture}
Signed-By: /etc/apt/keyrings/docker.asc
EOF
}

install_docker_engine() {
    run_as_root apt-get update -y
    run_as_root apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

    if have systemctl && systemctl list-unit-files docker.service >/dev/null 2>&1; then
        run_as_root systemctl start docker
    fi
}

# DOCKER_ADD_USER_TO_GROUP=true のときだけ、sudo なしで docker を使えるようにする
configure_docker_group() {
    local target_user="${USER:-$(id -un)}"

    if [[ "${DOCKER_ADD_USER_TO_GROUP:-false}" == "true" ]]; then
        run_as_root groupadd -f docker
        run_as_root usermod -aG docker "${target_user}"
        info "Docker group updated for ${target_user}. Log out and back in before running docker without sudo."
    else
        info "Docker installed. Use sudo for docker commands, or rerun with DOCKER_ADD_USER_TO_GROUP=true to add ${target_user} to the docker group."
    fi
}

install_module_extras() {
    [[ "${OS}" == "ubuntu" ]] || die_unsupported_os

    remove_conflicting_docker_packages
    add_docker_apt_repository
    install_docker_engine
    configure_docker_group
}
