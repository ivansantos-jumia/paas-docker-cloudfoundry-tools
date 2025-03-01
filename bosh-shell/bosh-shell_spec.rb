require 'spec_helper'
require 'docker'
require 'serverspec'

BOSH_CLI_VERSION="5.5.1-7850ac98-2019-05-21T22:28:36Z"

describe "bosh-shell image" do
  before(:all) {
    set :docker_image, find_image_id('bosh-shell:latest')
  }

  it "has the expected version of the Bosh CLI" do
    expect(
      command("bosh --version").stdout.strip
    ).to eq("version #{BOSH_CLI_VERSION}")
  end

  it "has `file` available" do
    expect(
      command("file --version").exit_status
    ).to eq(0)
  end

  it "has ssh available" do
    expect(
      command("ssh -V").exit_status
    ).to eq(0)
  end

  it "can run git" do
    expect(command('git --version').exit_status).to eq(0)
  end

  it "has `bash` available" do
    expect(
      command("bash --version").exit_status
    ).to eq(0)
  end

  it "has a new enough version of openssl available" do
    # wget (from busybox) requires openssl to be able to connect to https sites.

    # See https://github.com/nahi/httpclient/blob/v2.7.1/lib/httpclient/ssl_config.rb#L441-L452
    # (httpclient is a dependency of bosh_cli)
    # With an older version of openssl, bosh_cli spits out warnings.
    cmd = command("openssl version")
    expect(cmd.exit_status).to eq(0)

    ssl_version_str = cmd.stdout.strip
    if ssl_version_str.start_with?('OpenSSL 1.0.1')
      expect(ssl_version_str).to be >= 'OpenSSL 1.0.1p'
    else
      expect(ssl_version_str).to be >= 'OpenSSL 1.0.2d'
    end
  end

  it "has `vim` available" do
    expect(
      command("vim --version").exit_status
    ).to eq(0)
  end
end
