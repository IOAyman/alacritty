# Stage 1
FROM fedora AS BUILD
RUN dnf install -y cmake freetype-devel fontconfig-devel xclip gcc curl
RUN curl https://sh.rustup.rs -sSfo /usr/bin/rust_installer \
    && chmod 555 /usr/bin/rust_installer \
    && /usr/bin/rust_installer -y
ENV PATH /root/.cargo/bin:$PATH

WORKDIR /build
ADD . .
RUN rustup override set stable && rustup update stable
RUN cargo build --release


# Stage 2
FROM scratch
WORKDIR /alacritty
COPY --from=BUILD /build/target/release/alacritty .
COPY --from=BUILD /build/alacritty.yml alacritty.yml
# CMD ['./alacritty', '--config-file', './alacritty.yml']
