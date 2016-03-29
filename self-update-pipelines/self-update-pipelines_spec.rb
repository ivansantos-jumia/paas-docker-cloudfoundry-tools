require 'spec_helper'
require 'docker'
require 'serverspec'

AWSCLI_BIN = "/usr/local/bin/aws"
AWSCLI_VERSION = "1.9.21"

describe "self-update-pipelines image" do
  before(:all) {
    set :docker_image, find_image_id('self-update-pipelines:latest')
  }

  it "has ruby available" do
    expect(
      command("ruby -v").stdout
    ).to match(/ruby 2\.2/)
  end

  it "has curl available" do
    expect(
      command("curl --version").stdout
    ).to match(/curl 7\.38/)
  end

  it "has bash available" do
    expect(
      command("bash --version").stdout
    ).to match(/GNU bash, version 4\.3/)
  end

  it "has make available" do
    expect(
      command("make --version").stdout
    ).to match(/GNU Make 4/)
  end

  it "checks if 'aws' binary exists and is a file" do
    expect(file(AWSCLI_BIN)).to be_file
  end

  it "checks if 'aws' binary is executable" do
    expect(file(AWSCLI_BIN)).to be_mode 755
  end

  it "has the 'aws' version #{AWSCLI_VERSION}" do
    def awscli_version
      command("aws --version").stderr.strip
    end
    expect(awscli_version).to match(/aws-cli\/#{AWSCLI_VERSION} /)
  end

  it "the 'aws help' command works" do
    expect(command("aws help").stdout.gsub(/\s+/, "\s")).to match(/The AWS Command Line Interface/)
  end
end
