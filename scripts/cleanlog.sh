#!/bin/bash
# 使い方: ./cleanlog.sh 入力ファイル [出力ファイル]
# script コマンドで記録したlogから、色・カーソル制御などの
# エスケープシーケンスを取り除いた読みやすい版を作る。
#
# 例:
#   script -a chap3/command.log     # 記録開始 (これまで通り)
#   ... 作業 ...
#   exit                            # 記録終了
#   ./cleanlog.sh chap3/command.log chap3/command_clean.log

in="$1"
out="${2:-/dev/stdout}"

if [ -z "$in" ]; then
    echo "使い方: $0 入力ファイル [出力ファイル]" >&2
    exit 1
fi

sed -r 's/\x1b\[[0-9;?]*[a-zA-Z]//g; s/\x1b\][^\a]*\a//g' "$in" \
    | col -bx \
    | sed -E 's/^[^@[:space:]]+@[^:[:space:]]+:[^$]*\$ ?//' \
    > "$out"


