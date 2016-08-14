FROM cviebig/arch-base

RUN pacman -S --noprogressbar --noconfirm --needed base-devel boost llvm clang cmake ninja git && \
    pacman -Scc --noconfirm && \
    rm -rf /usr/share/man/*
