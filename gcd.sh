#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 <自然数1> <自然数2>" >&2
  exit 1
}

# 引数チェック
if [ $# -ne 2 ]; then
  usage
fi

re='^[0-9]+$'
for v in "$1" "$2"; do
  if ! [[ $v =~ $re ]] || [ "$v" -le 0 ]; then
    echo "Error: 引数が自然数でない" >&2
    exit 1
  fi
done

a=$1
b=$2

# Euclid の互除法
while [ "$b" -ne 0 ]; do
  tmp=$b
  b=$(( a % b ))
  a=$tmp
done

echo "$a"
