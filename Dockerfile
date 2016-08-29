FROM cviebig/arch-base

RUN pacman -S --noprogressbar --noconfirm --needed base-devel boost llvm clang cmake ninja git && \
    pacman -Scc --noconfirm && \
    rm -rf /usr/share/man/*

#
# Build dependencies
#
RUN pacman -S --noprogressbar --noconfirm --needed bison doxygen flex gtest intel-tbb libxslt readline mercurial sparsehash texlive-core numactl openmp && \
    pacman -Scc --noconfirm && \
    mkdir -v -p /var/abs/local && \
    cd /var/abs/local && \
    git clone https://aur.archlinux.org/htslib.git && \
    git clone https://aur.archlinux.org/alglib.git && \
    git clone https://aur.archlinux.org/rapidjson-git.git && \
    git clone https://github.com/cviebig/archlinux-aur-samtools.git && \
    git clone https://github.com/cviebig/arch-aur-boost-compute.git boost-compute && \
    useradd -ms /bin/bash build || true && \
    chown -R build:build /var/abs/local && \
    chmod -R 744 /var/abs/local && \
    su -c "cd /var/abs/local/htslib && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/htslib/htslib-*-x86_64.pkg.tar.xz && \
    su -c "cd /var/abs/local/alglib && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/alglib/alglib-*-x86_64.pkg.tar.xz && \
    su -c "cd /var/abs/local/rapidjson-git && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/rapidjson-git/rapidjson-*-any.pkg.tar.xz && \
    su -c "cd /var/abs/local/archlinux-aur-samtools && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/archlinux-aur-samtools/samtools-*-x86_64.pkg.tar.xz && \
    su -c "cd /var/abs/local/boost-compute && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/boost-compute/boost-compute-*.pkg.tar.xz && \
    mkdir -v -p /usr/share/cmake/BoostCompute && \
    echo "set(BoostCompute_INCLUDE_DIRS \"/usr/include/boost\")" > /usr/share/cmake/BoostCompute/BoostComputeConfig.cmake && \
    rm -rf /var/abs/local/* && \
    pacman -Scc --noconfirm && \
    rm -rf /usr/share/man/*

#
# Flex
#
RUN pacman -S --noprogressbar --noconfirm help2man && \
    cd /var/abs/local && \
    git clone https://github.com/cviebig/arch-aur-flex-git.git flex-git && \
    chown -R build:build /var/abs/local && \
    chmod -R 744 /var/abs/local && \
    su -c "cd /var/abs/local/flex-git && makepkg" - build && \
    yes | pacman -U /var/abs/local/flex-git/flex-git-*-x86_64.pkg.tar.xz && \
    rm -rf /var/abs/local/* && \
    pacman -Rcs --noconfirm help2man && \
    pacman -Scc --noconfirm

# TODO: Remove when flex v2.6.2 is released
# see https://github.com/westes/flex/pull/65
