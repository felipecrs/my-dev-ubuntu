Vagrant.configure("2") do |config|
  # https://docs.vagrantup.com

  # https://app.vagrantup.com/felipecassiors/boxes/ubuntu1804-4dev
  config.vm.box = "felipecassiors/ubuntu1804-4dev"

  # Expose VM port to host, enable public access
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Expose VM port to host, disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Private network mode
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Bridge network mode
  # config.vm.network "public_network"

  # Share folder
  # config.vm.synced_folder "C:/", "/c/"
  config.vm.synced_folder "~/Repository", "/home/vagrant/Repository"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI
    vb.gui = true

    # Set the display name of the VM in VirtualBox
    vb.name = "my-bionic-4dev"

    # Customize the amount of memory on the VM:
    vb.memory = "8192"

    # Customize the amount of CPU on the VM:
    vb.cpus = "4"

    # Make the DNS calls be resolved on host
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

  end

  # Run a shell script in first run
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    set -euxo pipefail

    export DEBIAN_FRONTEND=noninteractive
    
    # Upgrade system
    sudo apt-get update
    sudo apt-get dist-upgrade -qq
    sudo snap refresh

    # Set keyboard layout to Portuguese (Brazil)
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'br')]"

    # Set timezone to America/Sao_Paulo
    sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/America/Sao_Paulo  /etc/localtime

    # Do not ask for https password on git every time
    git config --global credential.helper store
    
    # Set default browser

    # Disable welcome screen
    
  SHELL
end
