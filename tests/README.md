# Testing the dotfiles

This folder contains the automated tests for the scripts in this repository.
Most tests are written with [Bats](https://github.com/bats-core/bats-core)
(Bash Automated Testing System). One extra script, `shell-compat.sh`, checks
that the shared shell helpers load in both Bash and Zsh.

## Layout

The test folders mirror the layout of the repository:

| Folder | Tests for | Files |
|---|---|---|
| `tests/bin/` | scripts in `bin/` | `ansi_colors`, `battery-status`, `clean`, `extract`, `myip`, `remove`, `speedtest`, `update` |
| `tests/bootstrap/` | scripts in `bootstrap/` | `helpers`, `install`, `prerequisites`, `setup`, `symlink` |
| `tests/functions/` | scripts in `functions/` | `git`, `misc`, `python` |
| `tests/ssh/` | `ssh/upload_ssh_to_github.sh` | `upload_ssh_to_github` |
| `tests/shell-compat.sh` | `bash/` and `zsh/` helpers | not a Bats file |

Each `.bats` file tests one script. Its name matches the script's name, for
example `tests/bootstrap/install.bats` tests `bootstrap/install.sh`.

## Prerequisites

Install Bats (version 1.10 or newer is known to work):

```bash
# Debian / Ubuntu
sudo apt install bats

# macOS
brew install bats-core
```

Bash is required. Zsh is optional and only used by `shell-compat.sh`; the script
skips a shell that is not installed.

## Running the tests

Run from the repository root (`~/.dotfiles`).

```bash
# Run every Bats test in the repository
bats -r tests

# Run one test file
bats tests/bootstrap/install.bats

# Run all tests in one folder
bats tests/bin

# Run a single test by name (matches the text after @test)
bats tests/bootstrap/install.bats --filter "install_cli"

# Show the name of each test as it runs
bats --verbose-run tests/functions/git.bats

# Run the shell compatibility check (Bash and Zsh)
sh tests/shell-compat.sh
```

A passing run ends with `ok` for every test and exits with status `0`. A failing
test is printed as `not ok`, with the failed assertion and the file and line
number.

## How the tests are built

Every `.bats` file follows the same pattern:

1. `setup()` locates the repository root with `$BATS_TEST_FILENAME`, creates a
   temporary `$HOME`, and `source`s the script under test to load its functions.
   Scripts that run a main routine end with a guard such as
   `case "${0##*/}" in upload_ssh_to_github.sh) main "$@" ;; esac`, so the
   routine runs only when the script is executed directly. Keep this guard in
   any new script that is tested by sourcing it.
2. `teardown()` removes the temporary directories.
3. Each `@test` block calls a function and checks the result with `run` and
   assertions on `$status` and `$output`.

### Mocking external commands

Tests do not call real `sudo`, `apt`, `brew`, or network tools. They create a
fake executable in a temporary `MOCK_BIN` directory and put that directory first
on `PATH`. `tests/bootstrap/install.bats` has a helper for this:

```bash
make_mock sudo 'exit 0'
make_mock apt  'echo "apt $*" >> "$TEST_HOME/apt.log"; exit 0'
```

To check which commands ran, have the mock write its arguments to a log file
and `grep` that file in the test. Example from `install_cli`:

```bash
@test "install_cli updates and cleans up packages via apt" {
  make_mock sudo 'echo "sudo $*" >> "'"$TEST_HOME"'/sudo.log"; exit 0'
  make_mock apt 'exit 0'

  run install_cli

  [ "$status" -eq 0 ]
  grep -q "sudo apt update" "$TEST_HOME/sudo.log"
}
```

To test "no package manager found", the tests set `PATH` to `MOCK_BIN` alone,
so no real `apt` or `brew` can be found.

### Symlinks for hardcoded paths

Some scripts read files from `$HOME/.dotfiles/...` instead of a path relative
to themselves. `install.bats` handles this by creating `$TEST_HOME/.dotfiles/bootstrap/`
and symlinking only the files the script needs (`helpers.sh`). Other files, such
as `gui-apps.txt` or `Brewfile`, are created by each test that needs them, so the
real repository files do not affect the results.

## Adding a test

1. Find the test file that matches the script, or create `tests/<folder>/<name>.bats`
   for a new script.
2. Add a header comment with the run command, as the existing files do:

   ```bash
   #!/usr/bin/env bats
   # Unit tests for bootstrap/example.sh
   #
   # Run with:
   #   bats tests/bootstrap/example.bats
   ```

3. Use `setup()` and `teardown()` for temporary files. Never write to the real `$HOME`.
4. Mock every external command the script calls (see above).
5. Run the new file on its own, then run `bats -r tests` before committing.

## Known issues

No known failing tests at the time of writing. The full suite (182 tests)
passes with `bats -r tests`.
