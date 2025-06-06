#!/usr/bin/env bash
set -euo pipefail

SCRIPT="./gcd.sh"

# 失敗時にメッセージを出して exit 1
fail() {
  echo "✗ Test failed: $*" >&2
  exit 1
}

# テスト関数
#   $1 : 期待する終了ステータス (0:成功, ≠0:エラー)
#   $2 : 期待する標準出力 (終了コード≠0 の場合は空文字で OK)
#   $3…: gcd.sh に渡す引数
test_case() {
  local exp_code=$1; shift
  local exp_out=$1;   shift
  local args=("$@")

  local out
  local code=0
  if out=$("$SCRIPT" "${args[@]}" 2>&1); then
    code=0
  else
    code=$?
  fi

  if [ "$code" -ne "$exp_code" ]; then
    fail "args=${args[*]} expected exit=$exp_code, got=$code"
  fi
  if [ "$exp_code" -eq 0 ] && [ "$out" != "$exp_out" ]; then
    fail "args=${args[*]} expected output='$exp_out', got='$out'"
  fi

  echo "✓ Passed: args=${args[*]}"
}

echo "■ 正常系テスト"
test_case 0  2   2 4
test_case 0  1   7 3
test_case 0  5   5 10

echo
echo "■ 異常系テスト"
test_case 1  ""   3            # 引数１個
test_case 1  ""                # 引数０個
test_case 1  ""   -5 10        # 負の数
test_case 1  ""   -5.0 10      # 少数
test_case 1  ""   a b          # 文字列
test_case 1  ""   3 b          # 混在

echo
echo "All tests passed!"
