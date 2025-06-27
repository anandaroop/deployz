require "dry/cli"

module Deployz
  VERSION = "0.1.0"

  module Commands
    extend Dry::CLI::Registry

    class Default < Dry::CLI::Command
      desc "Show recent deployments for Artsy repos"

      def call(*)
        puts "Hello from Deployz!"
        puts "This will show recent deployments for Artsy repos."
        puts "Coming soon: GitHub integration to fetch deploy PRs."
      end
    end

    register "version", Default, aliases: ["", "default"]
  end

  class CLI
    def self.start(args)
      Dry::CLI.new(Commands).call
    end
  end
end