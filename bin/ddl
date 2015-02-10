#!/usr/bin/env bash

file "$(realpath $1)" | grep -q "shared object" || {
  echo "Argument error: address a shared object file" >&2
  exit 1
};

find $(nix-store -q --referrers "$1") -executable -type f -name '*.so' -exec sh -c '
  realpath {} | xargs ldd | grep -o "/nix/store/.* " | xargs realpath | sed "s,^,$(nix-store -q --deriver {}):,"
' ';'  | sort -u | grep "$(realpath $1)" | grep -Po '^.*(?=:)'
