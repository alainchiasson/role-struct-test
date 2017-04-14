# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

 N = 1
 (1..N).each do |machine_id|
   config.vm.define "ceph-#{machine_id}" do |machine|

     machine.vm.hostname = "ceph-#{machine_id}"
     machine.vm.box = "bento/centos-7.3"
     machine.vm.box_check_update = true
     machine.vm.network "private_network", type: "dhcp"
     machine.vm.provider "virtualbox" do |vb|
       vb.memory = "1024"
     end


     # Only execute once the Ansible provisioner,
     # when all the machines are up and ready.
     if machine_id == N
       machine.vm.provision :ansible do |ansible|

         ansible.groups = {
           "all" => ["ceph-[1:#{N}]"]
         }

         ansible.limit = "all"
         ansible.playbook = "setup.yml"
       end
     end
   end
 end
end
