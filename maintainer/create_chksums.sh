#!/bin/sh

for f; do
  for m in md5 sha1 sha256 sha512; do
    printf '%-6s %s %s\n' $m $f $(${m}sum $f | awk '{ print $1 }')
  done
done
