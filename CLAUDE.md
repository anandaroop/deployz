# Deployz

A CLI tool to view recent deployment PRs for Artsy repositories with both interactive and non-interactive modes.

Provides a terminal-friendly alternative to visiting GitHub search URLs for Deploy PRs.

## Stack

- Language: Ruby
- Framework: Dry CLI
- Dependencies: octokit, rainbow, pastel
- Code quality: StandardRB

## Features

- **Two commands**: `list` (repo-separated view) and `timeline` (chronological view)
- **Interactive mode**: Prompts for repo selection
- **Non-interactive mode**: Pass repos as arguments
- **Date filtering**: `--days N` option (default: 10 days)
- **GitHub authentication**: GITHUB_TOKEN support for private repos
- **Colorized output**: Each repo has distinct colors
- **Visual timeline**: Box drawing characters create clear columns

## Commands

### List Command
- `deployz list` - Interactive repo selection
- `deployz list gravity metaphysics force` - Specific repos
- `deployz list --days 7` - Last 7 days
- Shows Deploy PRs grouped by repository

### Timeline Command  
- `deployz timeline` - Interactive repo selection
- `deployz timeline metaphysics force --days 30` - Specific repos, 30 days
- Shows chronological timeline with colored vertical columns
- Each repo has staggered indentation for visual separation

### Shortcuts
- `deployz gravity metaphysics` - Defaults to list command
- `deployz l` - List alias
- `deployz t` - Timeline alias

## Conventions

- No fancy metaprogramming
- Lint after each change, and use autofixing
- Use conventional commit formatting for commit messages
- Space-delimited repo names (not comma-delimited)
