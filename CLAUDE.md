# Deployz

This CLI's purpose is to inform the user of recently deployed projects at Artsy

It provides a terminal-friendly and easily grokked alternative to visiting an URL such as https://github.com/search?q=org%3Aartsy+is%3Apr+in%3Atitle+Deploy&type=pullrequests&s=created&o=desc&p=5

## Stack

- Language: Ruby
- Framework: Dry
- Code quality: StandardRB

## Conventions

- No fancy metaprogramming
- Lint after each change
- Use convention commit formatting for commit messages

## Example session

```sh
> deployz

Which repos (default: gravity,metaphysics,force):

Retrieving deploy PRs for gravity, metaphysics and force.

[fetch via Github API the equivalent of `org:artsy is:pr in:title Deploy` sorted by reverse chron, for the last week]

[visualize in a terminal-friendly vertical timeline that shows each repo in its own color and column, with some kind of marker to indicate when it was deployed]
```
