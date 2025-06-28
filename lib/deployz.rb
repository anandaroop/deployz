require "dry/cli"
require "octokit"
require "rainbow"

module Deployz
  VERSION = "0.1.0"

  module Commands
    extend Dry::CLI::Registry

    def self.get_repos_input(provided_repos = nil)
      if provided_repos && !provided_repos.empty?
        return provided_repos.join(" ")
      end
      
      print "Which repos? (default: gravity metaphysics force): "
      input = $stdin.gets.chomp
      input.empty? ? "gravity metaphysics force" : input
    end

    def self.generate_colors_for_repos(repo_list)
      colors = [:blue, :green, :magenta, :cyan, :yellow, :red, :white]
      color_map = {}
      repo_list.each_with_index do |repo, index|
        color_map[repo] = colors[index % colors.length]
      end
      color_map
    end

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
      
      argument :repos, type: :array, required: false, desc: "Repository names"

      def call(repos: nil, **)
        repos_string = Commands.get_repos_input(repos)
        puts Rainbow("Fetching Deploy PRs for: #{repos_string}").cyan

        token = ENV["GITHUB_TOKEN"]
        if token
          client = Octokit::Client.new(access_token: token)
        else
          puts Rainbow("Warning: No GITHUB_TOKEN found. Private repos may not be accessible.").yellow
          client = Octokit::Client.new
        end
        repo_list = repos_string.split(/\s+/)
        repo_colors = Commands.generate_colors_for_repos(repo_list)

        repo_list.each do |repo|
          color = repo_colors[repo]
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
            if e.message.include?("permission") || e.message.include?("cannot be searched")
              puts Rainbow("  Private repo - requires GITHUB_TOKEN with access").yellow
            else
              puts Rainbow("  Error fetching PRs for #{repo}: #{e.message}").red
            end
          end
        end
      end
    end

    class Timeline < Dry::CLI::Command
      desc "Show Deploy PRs in a visual timeline format"
      
      argument :repos, type: :array, required: false, desc: "Repository names"

      def call(repos: nil, **)
        repos_string = Commands.get_repos_input(repos)
        puts Rainbow("Creating timeline for: #{repos_string}").cyan

        token = ENV["GITHUB_TOKEN"]
        if token
          client = Octokit::Client.new(access_token: token)
        else
          puts Rainbow("Warning: No GITHUB_TOKEN found. Private repos may not be accessible.").yellow
          client = Octokit::Client.new
        end

        repo_list = repos_string.split(/\s+/)
        repo_colors = Commands.generate_colors_for_repos(repo_list)

        indent_size = 12
        repo_indents = {}
        repo_list.each_with_index do |repo, index|
          repo_indents[repo] = " " * (indent_size * (index + 1))
        end

        all_prs = []

        repo_list.each do |repo|
          search_query = "repo:artsy/#{repo} is:pr in:title Deploy"

          begin
            results = client.search_issues(search_query, sort: "created", order: "desc")

            results.items.first(20).each do |pr|
              all_prs << {
                repo: repo,
                pr: pr,
                color: repo_colors[repo] || :white,
                indent: repo_indents[repo] || ""
              }
            end
          rescue Octokit::Error => e
            if e.message.include?("permission") || e.message.include?("cannot be searched")
              puts Rainbow("Warning: #{repo} is private - requires GITHUB_TOKEN with access").yellow
            else
              puts Rainbow("Error fetching PRs for #{repo}: #{e.message}").red
            end
          end
        end

        all_prs.sort_by! { |item| item[:pr].created_at }.reverse!

        puts "\n#{Rainbow("Deploy Timeline").bold}"
        puts Rainbow("─" * 80).faint

        current_date = nil
        all_prs.each do |item|
          pr = item[:pr]
          color = item[:color]
          indent = item[:indent]

          pr_date = pr.created_at.strftime("%Y-%m-%d")
          if current_date != pr_date
            puts "\n#{Rainbow(pr_date).bold.underline}" if current_date
            current_date = pr_date
          end

          time = pr.created_at.strftime("%H:%M")

          puts "#{Rainbow(time).faint}#{indent}#{Rainbow(pr.html_url).color(color).bright}"
        end

        if all_prs.empty?
          puts Rainbow("No Deploy PRs found").yellow
        end
      end
    end

    register "version", Default, aliases: ["", "default"]
    register "list", List, aliases: ["l"]
    register "timeline", Timeline, aliases: ["t"]
  end

  class CLI
    def self.start(args)
      # Check if args contain repo names (no command specified)
      if args.length > 0 && !%w[list timeline version l t].include?(args[0])
        # Default to list command with repo args
        args.unshift("list")
      end

      Dry::CLI.new(Commands).call(arguments: args)
    end
  end
end
