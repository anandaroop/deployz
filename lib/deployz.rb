require "dry/cli"
require "octokit"

module Deployz
  VERSION = "0.1.0"

  module Commands
    extend Dry::CLI::Registry

    class Default < Dry::CLI::Command
      desc "Show recent deployments for Artsy repos"

      def call(*)
        puts "Hello from Deployz!"
        puts "This will show recent deployments for Artsy repos."
        puts "Try: deployz list"
      end
    end

    class List < Dry::CLI::Command
      desc "List recent Deploy PRs for Artsy repos"

      option :repos, type: :string, default: "gravity,metaphysics,force", desc: "Comma-separated list of repos"

      def call(repos: nil, **)
        puts "Fetching Deploy PRs for: #{repos}"

        client = Octokit::Client.new
        repo_list = repos.split(",").map(&:strip)

        repo_list.each do |repo|
          puts "\n--- #{repo.upcase} ---"
          search_query = "org:artsy repo:artsy/#{repo} is:pr in:title Deploy"

          begin
            results = client.search_issues(search_query, sort: "created", order: "desc")

            if results.items.empty?
              puts "No Deploy PRs found"
            else
              results.items.first(10).each do |pr|
                puts "#{pr.title} (##{pr.number}) - #{pr.created_at.strftime("%Y-%m-%d %H:%M")}"
              end
            end
          rescue Octokit::Error => e
            puts "Error fetching PRs for #{repo}: #{e.message}"
          end
        end
      end
    end

    register "version", Default, aliases: ["", "default"]
    register "list", List, aliases: ["l"]
  end

  class CLI
    def self.start(args)
      Dry::CLI.new(Commands).call
    end
  end
end
