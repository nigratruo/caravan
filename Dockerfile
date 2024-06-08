
# ______           _              __ _ _      
# |  _  \         | |            / _(_) |     
# | | | |___   ___| | _____ _ __| |_ _| | ___ 
# | | | / _ \ / __| |/ / _ \ '__|  _| | |/ _ \
# | |/ / (_) | (__|   <  __/ |  | | | | |  __/
# |___/ \___/ \___|_|\_\___|_|  |_| |_|_|\___|


FROM amd64/ubuntu:latest AS core

ENV PATH /usr/local/bin:$PATH

# apt-get config
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

# updates apt related thing
RUN apt-get update && apt upgrade -y \
  && apt-get install apt-file -y \
  && apt-file update

RUN apt-get install -y \
    locales tzdata \
    man man-db \
    ca-certificates libssl-dev\
    software-properties-common net-tools libtool 

RUN apt-get install -y \
    build-essential autoconf automake cmake cproto gettext g++ ninja-build \
    zlib1g-dev libffi-dev gnupg

# Commands
RUN apt-get install -y \
    zip unzip curl wget sed hstr sudo




#    ___                         _     _       
#   / _ \                       | |   | |      
#  / /_\ \___ ___  ___ _ __ ___ | |__ | |_   _ 
#  |  _  / __/ __|/ _ \ '_ ` _ \| '_ \| | | | |
#  | | | \__ \__ \  __/ | | | | | |_) | | |_| |
#  \_| |_/___/___/\___|_| |_| |_|_.__/|_|\__, |
#                                        __/ |
#                                       |___/ 


FROM core AS assembly

# Languages - Shell
RUN apt-get install -y \
    zsh

# Languages - Nodejs
RUN curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
RUN npm install -g npm \
  && npm install -g n \
  && n install latest
RUN npm install -g yarn && yarn config set workspaces-experimental true

# Languages - Python
RUN apt-get install -y \
    python-is-python3 pip

# Languages - Deno
RUN curl -fsSL https://deno.land/install.sh | sh

# Languages - Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Languages - Haskell Stack
RUN curl -sSL https://get.haskellstack.org/ | sh

# Languages - Scala
RUN curl -fL https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz | gzip -d > cs && chmod +x cs
RUN ./cs setup --yes


# Tools
# RUN apt-get install -y \
#     git vi nano

# Tools - nvim
RUN git clone https://github.com/neovim/neovim
RUN cd neovim \
    && make CMAKE_BUILD_TYPE=Release \
    && make install




# __      __ ___     ___     ___    _  _   
# \ \    / //   \   / __|   / _ \  | \| |  
#  \ \/\/ / | - |  | (_ |  | (_) | | .` |  
#   \_/\_/  |_|_|   \___|   \___/  |_|\_|  
# _|"""""|_|"""""|_|"""""|_|"""""|_|"""""| 
# "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 


FROM assembly AS wagon

##
# Locale
##

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.en


##
# Shell
##

RUN zsh
ENV SHELL /usr/bin/zsh


##
# User
## 

ENV USER you
ENV HOME /home/$USER

# Adapting credential
RUN useradd -m $USER
RUN gpasswd -a $USER sudo
RUN gpasswd -a $USER root
RUN echo "$USER:$USER" | chpasswd
RUN chmod g+rwx /root
RUN chmod g+rwx $HOME/.cache

##
# Workspace
##
USER $USER
WORKDIR $HOME
COPY --chmod=0755 --chown=$USER burden/ .

CMD [ "sh", "-c", "$SHELL" ]
