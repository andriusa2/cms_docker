#!/bin/sh
# Set up pyenv under /usr/local/lib/pyenv and configure it for current user.
set -eux
# Recommended deps as per pyenv docs:
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt-get install -y git build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Set up pyenv under /usr/local/lib/pyenv
PYENV_ROOT=/usr/local/lib/pyenv
sudo mkdir -p "$PYENV_ROOT"
sudo chown "$USER" "$PYENV_ROOT"
git clone 'https://github.com/pyenv/pyenv.git' "$PYENV_ROOT"
git clone 'https://github.com/pyenv/pyenv-doctor.git' "$PYENV_ROOT/plugins/pyenv-doctor"
git clone 'https://github.com/pyenv/pyenv-update.git' "$PYENV_ROOT/plugins/pyenv-update"
git clone 'https://github.com/pyenv/pyenv-virtualenv.git' "$PYENV_ROOT/plugins/pyenv-virtualenv"

# Check cpython build dependencies.
"$PYENV_ROOT/bin/pyenv" doctor

# Set it up for current user
# Interactive shell.
{
  echo "export PYENV_ROOT='$PYENV_ROOT'"
  # shellcheck disable=SC2016
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'eval "$(pyenv init -)"'
} | tee -a ~/.bashrc ~/.pyenv_script >> ~/.profile

