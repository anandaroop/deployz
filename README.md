# Deployz

A CLI tool to view recent deployment PRs for Artsy repositories.

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

### List recent Deploy PRs (default repos: gravity, metaphysics, force)

```bash
./bin/deployz list
```

### List Deploy PRs for specific repositories

```bash
./bin/deployz list --repos metaphysics,force
./bin/deployz list --repos gravity
```

### Show help

```bash
./bin/deployz version
./bin/deployz list --help
```

## Output

The tool displays Deploy PRs with:

- Timestamps at the beginning for chronological scanning
- Colored repo section headers (blue, green, magenta)
- Clickable GitHub URLs (cmd+click in Terminal.app)
- Error handling for private repos without authentication

## Examples

With GitHub token configured:

```
Fetching Deploy PRs for: gravity,metaphysics,force

--- GRAVITY ---
  2025-06-27 07:42 - Deploy https://github.com/artsy/gravity/pull/1234
  2025-06-26 16:52 - Deploy https://github.com/artsy/gravity/pull/1233

--- METAPHYSICS ---
  2025-06-27 07:42 - Deploy https://github.com/artsy/metaphysics/pull/6858
  2025-06-26 16:52 - Deploy https://github.com/artsy/metaphysics/pull/6855
```

Without GitHub token:

```
Warning: No GITHUB_TOKEN found. Private repos may not be accessible.

--- GRAVITY ---
  Private repo - requires GITHUB_TOKEN with access
```
