class ContainerMaker
  attr_accessor :lxc, :name

  def initialize(name)
    @name = name
    @lxc = Lxc.new
  end

  def create_if_needed
    lxc.create_container(name) unless lxc.container_exists?(name)
  end

  def add_public_key
    puts "Add public key to #{name}"
    `lxc file push #{public_key_file} #{name}/root/.ssh/authorized_keys`
    lxc.run_command(name, "chmod 0600 /root/.ssh/authorized_keys")
    lxc.run_command(name, "chown root:root /root/.ssh/authorized_keys")
  end

  def add_to_hosts
    puts "Add #{name} to hosts file"
    hosts_contents = File.read("/etc/hosts")
    File.write("hosts", new_hosts_contents(hosts_contents))
  end

  def new_hosts_contents(old_hosts_contents)
    new_lines = ""
    hosts_lines = old_hosts_contents.split("\n")
    hosts_lines.delete_if do |line|
      line =~ / #{name}$/
    end
    hosts_lines << "#{ip_address} #{name}\n"
    hosts_lines.join("\n")
  end

  def ip_address
    command = "lxc info #{name} | grep 'eth0..inet\t'"
    eth0_line = `lxc info #{name} | grep 'eth0..inet\t'`
    matches = /(\d+\.\d+\.\d+\.\d+)/.match(eth0_line)
    matches[1]
  end

  def show_info
    puts "#{name}: #{ip_address}"
  end

  def public_key_file
    home_dir = ENV["HOME"]
    "#{home_dir}/.ssh/id_rsa.pub"
  end
end

class Lxc
  def default_image
    "ubuntu:16.04"
  end

  def run_command(container_name, command)
    `lxc exec #{container_name} -- #{command}`
  end

  def container_exists?(container_name)
    lines_with_container = `lxc list | grep ' #{container_name} '`
    lines_with_container.size > 0
  end

  def create_container(container_name)
    puts "Creating container #{container_name}"
    command = "lxc launch #{default_image} #{container_name}"
    `lxc launch #{default_image} #{container_name}`
  end
end

