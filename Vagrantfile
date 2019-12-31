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

  # Insert SSH key
  if Vagrant::Util::Platform.windows?
    if File.exists?(File.join(Dir.home, ".ssh", "id_rsa"))
      ssh_key = File.read(File.join(Dir.home, ".ssh", "id_rsa"))
      config.vm.provision "shell", privileged: false, inline: <<-SHELL
        set -euo pipefail
        echo 'Windows-specific: Copying local SSH Key to VM for provisioning...'
        mkdir -p /home/vagrant/.ssh
        echo '#{ssh_key}' > /home/vagrant/.ssh/id_rsa
        chmod 600 /home/vagrant/.ssh/id_rsa
        # ssh-add
      SHELL
    else
      # Else, throw a Vagrant Error. Cannot successfully startup on Windows without a GitHub SSH Key!
      raise Vagrant::Errors::VagrantError, "\n\nERROR: SSH Key not found at ~/.ssh/id_rsa (required on Windows).\nYou can generate this key manually by using ssh-keygen\n\n"
    end
  end

  # Check if we run in a Inatel computer
  require 'socket'
  inatel = Socket.gethostbyname(Socket.gethostname).first.end_with?("inatel.br")

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

    # Set git name
    if [ '#{inatel}' = true ]; then
      git config --global user.name "Felipe de Cássio Rocha Santos"
      git config --global user.email felipesantos@inatel.br
    else
      git config --global user.name "Felipe Santos"
      git config --global user.email felipecassiors@gmail.com
    fi

  SHELL

end
