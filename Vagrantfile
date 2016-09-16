# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/centos-7.2"

  config.vm.network "public_network", ip: "192.168.0.120", bridge: "en0: Wi-Fi (AirPort)"


  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
  end

  config.vm.provision "shell", inline: <<-SHELL
    #!/usr/bin/env bash
    # This bootstraps Puppet on CentOS 7.x
    # It has been tested on CentOS 7.0 64bit

    set -e

    REPO_URL="http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm"

    if [ "$EUID" -ne "0" ]; then
    echo "This script must be run as root." >&2
    exit 1
    fi

    if which puppet > /dev/null 2>&1; then
    echo "Puppet is already installed."
    exit 0
    fi

    # Install wget
    echo "Installing wget..."
    yum install -y wget > /dev/null


    # Install puppet labs repo
    echo "Configuring PuppetLabs repo..."
    repo_path=$(mktemp)
    wget --output-document="${repo_path}" "${REPO_URL}" 2>/dev/null
    rpm -i "${repo_path}" >/dev/null

    # Install Puppet...
    echo "Installing puppet"
    yum install -y puppet > /dev/null

    echo "Puppet installed!"
  SHELL

  config.vm.provision :puppet do |puppet|
      puppet.module_path = ["modules", 'site']
      # puppet.hiera_config_path = "hiera.yaml"
      # puppet.options="--fileserverconfig=/vagrant/puppet/fileserver.conf --summarize --verbose"
  end

  config.vm.post_up_message = "http://192.168.0.120:3000 http://192.168.0.120:8083"
end
