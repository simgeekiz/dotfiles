#!/usr/bin/env bats
# Unit tests for bin/myip
#
# Run with:
#   bats tests/bin/myip.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bin/myip"

  MOCK_BIN="$(mktemp -d)"
  export PATH="$MOCK_BIN:$PATH"

  source "$SCRIPT"
}

teardown() {
  rm -rf "$MOCK_BIN"
}

make_mock() {
  name=$1
  body=$2
  cat > "$MOCK_BIN/$name" <<EOF
#!/bin/sh
$body
EOF
  chmod +x "$MOCK_BIN/$name"
}

# --- parse_args ---

@test "parse_args --help exits 0 and prints usage" {
  run parse_args --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "parse_args rejects an unknown option" {
  run parse_args --bogus
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unknown option"* ]]
}

# --- get_ip_linux ---

@test "get_ip_linux uses 'ip route get' when ip is available" {
  make_mock ip 'echo "1.2.3.4 via 10.0.0.1 dev eth0 src 192.168.1.50 uid 1000"'

  run get_ip_linux

  [ "$output" = "192.168.1.50" ]
}

@test "get_ip_linux falls back to ifconfig when ip is unavailable" {
  make_mock ifconfig 'printf "eth0: flags up\n        inet 192.168.1.77  netmask 255.255.255.0  broadcast 192.168.1.255\n"'

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ] && [ "$2" = "ip" ]; then
        return 1
      fi
      builtin command "$@"
    }
    get_ip_linux
  '

  [ "$output" = "192.168.1.77" ]
}

@test "get_ip_linux fails when no suitable command is found" {
  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          ip|ifconfig) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    get_ip_linux
  '
  [ "$status" -eq 1 ]
  [[ "$output" == *"No suitable command found"* ]]
}

# --- main OS dispatch ---

@test "main dispatches to get_ip_linux on Linux" {
  make_mock ip 'echo "1.2.3.4 via 10.0.0.1 dev eth0 src 10.10.10.10 uid 1000"'

  run bash -c 'source "'"$SCRIPT"'"; uname() { echo Linux; }; main'

  [ "$output" = "10.10.10.10" ]
}

@test "main reports an unsupported OS" {
  run bash -c 'source "'"$SCRIPT"'"; uname() { echo Plan9; }; main'

  [ "$status" -eq 1 ]
  [[ "$output" == *"Unsupported OS"* ]]
}
