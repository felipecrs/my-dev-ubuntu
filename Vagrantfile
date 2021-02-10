Vagrant.configure("2") do |config|
  # https://docs.vagrantup.com

  # https://app.vagrantup.com/felipecrs/boxes/ubuntu1804-4dev
  config.vm.box = "felipecrs/dev-ubuntu"

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
  config.vm.synced_folder "~/Repos", "/home/vagrant/Repos"

  # Check if we run in a Inatel computer
  require 'socket'
  inatel = Socket.gethostbyname(Socket.gethostname).first.end_with?("inatel.br")

  config.vm.provider "virtualbox" do |vb|
    # Set the display name of the VM in VirtualBox
    vb.name = "dev-ubuntu"
    # Customize the amount of memory on the VM:
    vb.memory = "8192"
    # Customize the amount of CPU on the VM:
    if inatel
      vb.cpus = "2"
    else
      vb.cpus = "4"
    end
  end

  # Workaround to forward ssh key from Windows Host with Git Bash
  # (doesn't seems to be needed anymore)
  # if Vagrant::Util::Platform.windows?
  #   if File.exists?(File.join(Dir.home, ".ssh", "id_rsa"))
  #       # Read local machine's SSH Key (~/.ssh/id_rsa)
  #       ssh_key = File.read(File.join(Dir.home, ".ssh", "id_rsa"))
  #       # Copy it to VM as the /vagrant/.ssh/id_rsa key
  #       config.vm.provision :shell, privileged: false, :inline => "echo 'Windows-specific: Copying local SSH Key to VM for provisioning...' && mkdir -p /home/vagrant/.ssh && echo '#{ssh_key}' > /home/vagrant/.ssh/id_rsa && chmod 600 /home/vagrant/.ssh/id_rsa", run: "always"
  #   else
  #       # Else, throw a Vagrant Error. Cannot successfully startup on Windows without a SSH Key!
  #       raise Vagrant::Errors::VagrantError, "\n\nERROR: SSH Key not found at ~/.ssh/id_rsa.\nYou can generate this key manually by running `ssh-keygen` in Git Bash.\n\n"
  #   end
  # end

  # Run a shell script in first run
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    set -euxo pipefail

    APT_GET='sudo DEBIAN_FRONTEND=noninteractive apt-get'

    # Upgrade system
    $APT_GET update
    $APT_GET dist-upgrade -y
    $APT_GET autoremove -y
    sudo snap refresh

    # Set keyboard layout to Portuguese (Brazil)
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'br')]"

    # Set timezone to America/Sao_Paulo
    sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/America/Sao_Paulo  /etc/localtime

    # Set git name
    if [ '#{inatel}' = true ]; then
      git config --global user.name "Felipe de Cássio Rocha Santos"
      git config --global user.email felipesantos@inatel.br
    else
      git config --global user.name "Felipe Santos"
      git config --global user.email felipecassiors@gmail.com
    fi
  SHELL

  # Check if SSH agent forward is working
  # config.vm.provision "shell", privileged: false, inline: "ssh -o StrictHostKeyChecking=no -T git@github.com", run: "always"

end
