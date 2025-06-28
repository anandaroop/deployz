# Deployz

A CLI tool to view recent deployment PRs for Artsy repositories with both interactive and non-interactive modes.

## Installation

```bash
git clone <repo-url>
cd deployz
bundle install
```

## GitHub Token Setup

To access private repositories like `gravity`, you need a GitHub personal access token.

### Creating a GitHub Token

1. Go to [GitHub Settings > Personal Access Tokens](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Give it a descriptive name like "Deployz CLI"
4. Select the following scopes:
   - `repo` (Full control of private repositories)
   - `public_repo` (Access public repositories)
5. Click "Generate token"
6. Copy the token immediately (you won't see it again)

### Configuring the Token

Set the `GITHUB_TOKEN` environment variable:

```bash
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
export GITHUB_TOKEN=your_token_here

# Or set temporarily for one session
export GITHUB_TOKEN=your_token_here
```

## Usage

### Interactive Mode (prompts for repo selection)

```bash
./bin/deployz list
./bin/deployz timeline
```

### Non-Interactive Mode (specify repos directly)

```bash
# Defaults to list command
./bin/deployz gravity metaphysics force

# Explicit commands
./bin/deployz list gravity metaphysics force
./bin/deployz timeline metaphysics force

# With date filtering
./bin/deployz list gravity --days 7
./bin/deployz timeline metaphysics force --days 30
```

### Command Aliases

```bash
./bin/deployz l           # list alias
./bin/deployz t           # timeline alias
```

### Options

- `--days N` - Number of days to look back (default: 10)
- Repository names are space-delimited (not comma-delimited)

## Commands

### List Command
Shows Deploy PRs grouped by repository with colored section headers.

### Timeline Command  
Shows Deploy PRs in chronological order with:
- Colored vertical columns for each repository
- Staggered indentation for visual separation
- Box drawing characters (┃) for clear column tracking

## Output Features

- **Timestamps** at the beginning for chronological scanning
- **Colored output** with distinct colors per repository
- **Clickable GitHub URLs** (cmd+click in Terminal.app)
- **Date range filtering** for consistent time windows
- **Error handling** for private repos without authentication

## Examples

### List Command

```
$ ./bin/deployz list gravity metaphysics --days 5
Fetching Deploy PRs for: gravity metaphysics (last 5 days)

--- GRAVITY ---
  2025-06-27 07:42 - Deploy https://github.com/artsy/gravity/pull/1234
  2025-06-26 16:52 - Deploy https://github.com/artsy/gravity/pull/1233

--- METAPHYSICS ---
  2025-06-27 07:42 - Deploy https://github.com/artsy/metaphysics/pull/6858
  2025-06-26 16:52 - Deploy https://github.com/artsy/metaphysics/pull/6855
```

### Timeline Command

```
$ ./bin/deployz timeline metaphysics force --days 7
Creating timeline for: metaphysics force (last 7 days)

Deploy Timeline
────────────────────────────────────────────────────────────────────────────────
07:42            ┃ https://github.com/artsy/metaphysics/pull/6858
2025-06-26
17:02                        ┃ https://github.com/artsy/force/pull/15776
16:52            ┃ https://github.com/artsy/metaphysics/pull/6855
```

### Interactive Mode

```
$ ./bin/deployz timeline
Which repos? (default: gravity metaphysics force): metaphysics force
Creating timeline for: metaphysics force (last 10 days)
...
```

### Without GitHub Token

```
Warning: No GITHUB_TOKEN found. Private repos may not be accessible.

--- GRAVITY ---
  Private repo - requires GITHUB_TOKEN with access
```

## Development

### Code Quality
```bash
bundle exec standardrb        # Check code style
bundle exec standardrb --fix  # Auto-fix issues
```
