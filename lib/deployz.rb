require "dry/cli"
require "octokit"
require "rainbow"

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

      option :repos, type: :string, default: "metaphysics,force", desc: "Comma-separated list of repos"

      def call(repos: nil, **)
        puts Rainbow("Fetching Deploy PRs for: #{repos}").cyan

        client = Octokit::Client.new
        repo_list = repos.split(",").map(&:strip)
        colors = [:blue, :green, :magenta]

        repo_list.each_with_index do |repo, index|
          color = colors[index % colors.length]
          puts "\n#{Rainbow("--- #{repo.upcase} ---").color(color).bold}"
          search_query = "repo:artsy/#{repo} is:pr in:title Deploy"

          begin
            results = client.search_issues(search_query, sort: "created", order: "desc")

            if results.items.empty?
              puts Rainbow("  No Deploy PRs found").yellow
            else
              results.items.first(10).each do |pr|
                pr_url = Rainbow(pr.html_url).bright.color(color)
                date = Rainbow(pr.created_at.strftime("%Y-%m-%d %H:%M")).faint
                puts "  #{date} - #{pr.title} #{pr_url}"
              end
            end
          rescue Octokit::Error => e
            puts Rainbow("  Error fetching PRs for #{repo}: #{e.message}").red
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
