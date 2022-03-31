Vagrant.configure("2") do |config|

	if Vagrant.has_plugin? "vagrant-vbguest"
		config.vbguest.no_install = true
		config.vbguest.auto_update = false
		config.vbguest.no_remote = true
	end
	
	config.vm.define :firewall do |firewall|
		firewall.vm.box = "centos/stream8"
		firewall.vm.network :public_network, ip: "192.168.10.15"
		firewall.vm.network :private_network, ip: "192.168.100.2"
		firewall.vm.provision "shell", path: "ambiente.sh"
		firewall.vm.provision "shell", path: "firewall.sh"
		firewall.vm.hostname = "firewall.daanez.com"
	end
	
	config.vm.define :servidor3 do |servidor3|
		servidor3.vm.box = "centos/stream8"
		servidor3.vm.network :private_network, ip: "192.168.100.4"
		servidor3.vm.provision "shell", path: "ambiente.sh"
		servidor3.vm.provision "shell", path: "dnsmaestro.sh"
		servidor3.vm.hostname = "servidor3.daanez.com"
	end
	
	config.vm.define :servidor2 do |servidor2|
		servidor2.vm.box = "centos/stream8"
		servidor2.vm.network :private_network, ip: "192.168.100.3"
		servidor2.vm.provision "shell", path: "ambiente.sh"
		servidor2.vm.provision "shell", path: "ftp.sh"
		servidor2.vm.provision "shell", path: "dnsesclavo.sh"
		servidor2.vm.hostname = "servidor2.daanez.com"
	end
end