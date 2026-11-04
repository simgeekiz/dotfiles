#!/usr/bin/env bats
# Unit tests for functions/git.sh
#
# Run with:
#   bats tests/functions/git.bats
#
# Uses a real throwaway git repo as $HOME so these functions run against
# actual git plumbing, without touching your real repositories.

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/functions/git.sh"

  TEST_REPO="$(mktemp -d)"
  cd "$TEST_REPO" || exit 1
  git init -q
  git config user.email "test@example.com"
  git config user.name "Test User"
  echo "hello" > file.txt
  git add file.txt
  git commit -qm "initial commit"

  source "$SCRIPT"
}

teardown() {
  cd /
  rm -rf "$TEST_REPO"
}

# --- gitaddtag / gaddtag ---

@test "gitaddtag requires a tag name" {
  run gitaddtag

  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage: gitaddtag"* ]]
}

@test "gitaddtag creates an annotated tag on HEAD" {
  run gitaddtag "v1.0.0"

  [ "$status" -eq 0 ]
  run git tag -l "v1.0.0"
  [[ "$output" == "v1.0.0" ]]
}

@test "gaddtag is an alias for gitaddtag" {
  run gaddtag "v2.0.0" "release message"

  [ "$status" -eq 0 ]
  run git tag -l "v2.0.0"
  [[ "$output" == "v2.0.0" ]]
}

# --- gitdeltag / gdeltag ---

@test "gitdeltag requires a tag name" {
  run gitdeltag

  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage: gitdeltag"* ]]
}

@test "gitdeltag removes an existing local tag" {
  git tag "to-delete"

  run gitdeltag "to-delete"

  [ "$status" -eq 0 ]
  run git tag -l "to-delete"
  [ -z "$output" ]
}

@test "gdeltag is an alias for gitdeltag" {
  git tag "to-delete-2"

  run gdeltag "to-delete-2"

  [ "$status" -eq 0 ]
  run git tag -l "to-delete-2"
  [ -z "$output" ]
}

# --- gitaddtagremote / gitdeltagremote ---
# These just push/delete a remote tag; validate only the argument guard,
# since exercising a real remote push is out of scope for a unit test.

@test "gitaddtagremote requires a tag name" {
  run gitaddtagremote

  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage: gitaddtagremote"* ]]
}

@test "gitdeltagremote requires a tag name" {
  run gitdeltagremote

  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage: gitdeltagremote"* ]]
}

# --- gitaddremote / gaddremote ---

@test "gitaddremote requires both a name and a url" {
  run gitaddremote "origin"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage: gitaddremote"* ]]
}

@test "gitaddremote adds a new remote" {
  run gitaddremote "myremote" "https://example.com/repo.git"

  [ "$status" -eq 0 ]
  run git remote get-url myremote
  [ "$output" = "https://example.com/repo.git" ]
}

@test "gaddremote is an alias for gitaddremote" {
  run gaddremote "myremote2" "https://example.com/repo2.git"

  [ "$status" -eq 0 ]
  run git remote get-url myremote2
  [ "$output" = "https://example.com/repo2.git" ]
}
