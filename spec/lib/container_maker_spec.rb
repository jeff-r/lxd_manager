$: << "."

require "lib/container_maker"

describe ContainerMaker do
  let(:maker) { ContainerMaker.new("foo") }
  let(:lxc) { "lxc" }

  before do
    allow(Lxc).to receive(:new).and_return(lxc)
    allow(maker).to receive(:`).with("lxc info foo | grep 'eth0..inet\t'").and_return("eth0:\tinet\t10.120.20.88\tvethB49G6C")
  end

  it "gets the ip address" do
    expect(maker.ip_address).to eql "10.120.20.88"
  end

  describe "#new_hosts_file" do
    let(:new_hosts_file) { "127.0.0.1 localhost\n10.120.20.88 foo\n" }

    before do
    end

    describe "when hosts doesn't already include the machine" do
      it "adds the entry" do
        old_hosts_file = "127.0.0.1 localhost"
        expect(maker.new_hosts_contents(old_hosts_file)).to eql new_hosts_file
      end
    end

    describe "when hosts already includes the machine" do
      it "updates the existing entry" do
        old_hosts_file = "127.0.0.1 localhost\n10.0.20.99 foo"
        expect(maker.new_hosts_contents(old_hosts_file)).to eql new_hosts_file
      end
    end
  end
end
