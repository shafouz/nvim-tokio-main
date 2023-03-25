FROM debian:sid-20211220

RUN apt-get update && apt-get -y install curl git cmake

COPY rust-analyzer /usr/bin/rust-analyzer
COPY nvim-linux64.deb /root/

# Cooperate NodeJS with Neovim.
# RUN npm i -g neovim
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install Neovim from source.
RUN dpkg -i /root/nvim-linux64.deb

# Install Vim Plug.
RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create directory for Neovim configuration files.
RUN mkdir -p /root/.config/nvim

# Copy Neovim configuration files.
COPY ./config/ /root/.config/nvim/
COPY ./testing/ /testing

# Install Neovim extensions.
RUN nvim --headless +PlugInstall +qall

WORKDIR /testing
RUN /root/.cargo/bin/cargo check
