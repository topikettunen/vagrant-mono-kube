# Change node memory and cpu amount accordingly
memory = 8192
maxmemory = 8192
cpus = 8

nodes = [
  {
    name: 'node1',
    ip: '192.168.50.6',
    memory: memory,
    maxmemory: maxmemory,
    cpus: cpus,
  }
]

$SCRIPT = <<-SCRIPT
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
     tee -a /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubectl docker.io
usermod -aG docker vagrant

wget https://github.com/rancher/rke/releases/download/v0.2.7/rke_linux-amd64
mv rke_linux-amd64 rke
chmod +x rke
mv rke /usr/local/bin/

su - vagrant -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa"
su - vagrant -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"

su - vagrant -c "rke up --config /vagrant/cluster.yml"
SCRIPT

Vagrant.configure('2') do |config|
  config.vm.box = 'generic/ubuntu1804'
  config.vm.box_check_update = true
  
  config.vbguest.auto_update = false
  
  nodes.each do |node|
    config.vm.define node[:name] do |nodespec|
      nodespec.vm.hostname = node[:name]
      nodespec.vm.provider 'virtualbox' do |vb, override|
        override.vm.box = "geerlingguy/ubuntu1804"
        override.vm.provision "shell", inline: $SCRIPT
        vb.gui = false
        vb.memory = node[:memory]
        vb.cpus = node[:cpus]
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "95"]
        override.vm.synced_folder ".", "/vagrant/",
                                  owner: "vagrant",
                                  group: "vagrant",
                                  mount_options: ["uid=900","gid=900","rw","dmode=0755","fmode=0775"]
        override.vm.synced_folder "~/.ssh", "/home/vagrant/.ssh-extra/",
                                  owner: "vagrant",
                                  group: "vagrant",
                                  mount_options: ["uid=900","gid=900","ro","dmode=0700","fmode=0600"]
        override.vm.network "private_network", ip: node[:ip]
      end
    end
    
    config.vm.define node[:name] do |nodespec|
      nodespec.vm.hostname = node[:name]
      nodespec.vm.provider 'hyperv' do |hv, override|
        override.vm.provision "shell", inline: $SCRIPT
        hv.memory = node[:memory]
        hv.cpus = node[:cpus]
        hv.maxmemory = node[:maxmemory]
        override.vm.synced_folder '.', '/vagrant/',
                                  owner: 'vagrant',
                                  group: 'vagrant',
                                  mount_options: ['uid=1000',
                                                  'gid=1000',
                                                  'rw',
                                                  'noperm',
                                                  'dir_mode=0755',
                                                  'file_mode=0775']
      end
    end
  end
end
