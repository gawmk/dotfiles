# shellcheck shell=bash
QS_VERSION=v0.3.2

if command -v qs >/dev/null; then
    log "quickshell present: $(qs --version 2>/dev/null | head -1)"
    return 0
fi

case "$DISTRO" in
    arch) pkg_install quickshell ;;
    debian)
        # not packaged on Debian: build an X11-only quickshell
        pkg_install cmake ninja-build pkg-config g++ spirv-tools libcli11-dev \
            qt6-base-dev qt6-base-private-dev qt6-declarative-dev qt6-declarative-private-dev \
            qt6-shadertools-dev qt6-svg-dev libxcb1-dev libdrm-dev libpipewire-0.3-dev libpam0g-dev \
            qml6-module-qtquick qml6-module-qtquick-controls qml6-module-qtquick-layouts \
            qml6-module-qtquick-templates qml6-module-qtquick-window qml6-module-qtqml-workerscript \
            qt6-svg-plugins
        dir="$HOME/source/quickshell"
        git_sync https://git.outfoxxed.me/quickshell/quickshell "$dir" "$QS_VERSION"
        qmldir="/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH)/qt6/qml"
        log "building quickshell $QS_VERSION (takes a few minutes)"
        cmake -S "$dir" -B "$dir/build" -G Ninja \
            -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr/local \
            -DINSTALL_QMLDIR="$qmldir" -DDISTRIBUTOR="gawmk/dotfiles" \
            -DWAYLAND=OFF -DCRASH_HANDLER=OFF -DUSE_JEMALLOC=OFF \
            -DSERVICE_POLKIT=OFF -DSERVICE_GREETD=OFF
        cmake --build "$dir/build"
        sudo cmake --install "$dir/build"
        ;;
esac
