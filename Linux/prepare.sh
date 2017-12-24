#!/usr/bin/env bash

sudo apt-get update \
	&& sudo apt-get install -y --no-install-recommends \
	wget \
	tree \
	apt-transport-https \
	build-essential \
	git \
	cmake \
	clang-format-5.0 \
	clang-tidy-5.0

# Install sublime-text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update \
	&& sudo apt-get install -y --no-install-recommends \
	sublime-text

# Use sublime-text as default editor for git
git config --global core.editor "subl -n -w"

# Make Projects directory
mkdir -p "/home/$USER/Projects"
