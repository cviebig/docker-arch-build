FROM cviebig/arch-base

RUN pacman -S --noprogressbar --noconfirm --needed base-devel boost llvm cmake ninja
