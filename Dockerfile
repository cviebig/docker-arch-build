FROM cviebig/arch-base

RUN pacman -S --noprogressbar --noconfirm --needed ca-certificates base-devel llvm cmake ninja
