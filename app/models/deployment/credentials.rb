# Top-level class for Deployments.
class Deployment
  # Set up ssh and netrc in the user's home directory
  class Credentials
    include ApiClient

    attr_accessor :root

    def initialize(root)
      @root = root
    end

    # Public: Create ssh and netrc config files
    #
    # Returns nothing.
    def setup!
      setup_ssh
      setup_netrc
    end

    private

    def netrc_config
      "#{root}/.netrc"
    end

    def ssh_directory
      "#{root}/.ssh"
    end

    def ssh_config
      "#{ssh_directory}/config"
    end

    def ssh_key
      "#{ssh_directory}/id_rsa"
    end

    def ssh_private_key
      ENV["DEPLOYMENT_PRIVATE_KEY"] || ""
    end

    def setup_ssh
      FileUtils.mkdir_p ssh_directory
      FileUtils.chmod_R 0700, ssh_directory

      File.open(ssh_key, "w", 0600) do |fp|
        fp.puts(ssh_private_key.split('\n'))
      end
      # put private key anyway
      puts ssh_private_key
      File.open(ssh_config, "w", 0600) do |fp|
        fp.puts <<-EOF
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
ForwardAgent yes
Host all
   Hostname *
   IdentityFile #{ssh_key}
   EOF
      end
    end

    def setup_netrc
      File.open(netrc_config, "w", 0600) do |fp|
        fp.puts <<-EOF
machine github.com
username #{github_token}
password x-oauth-basic
EOF
      end
    end
  end
end
