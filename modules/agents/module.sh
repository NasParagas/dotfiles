#!/usr/bin/env bash
# shellcheck shell=bash

# 各コーディングエージェントがグローバルに読む指示ファイルへ、同じ内容をリンクする。
# 本文を AGENTS.md と名付けないのは、このリポジトリの modules/agents/ 以下で作業するときに
# プロジェクトの規約として読まれないようにするため。
create_module_symlinks() {
    # Claude Code はグローバルの AGENTS.md を読まない
    symlink instructions.md "${HOME}/.claude/CLAUDE.md"
    symlink instructions.md "${CODEX_HOME:-${HOME}/.codex}/AGENTS.md"
    symlink instructions.md "${HOME}/.config/opencode/AGENTS.md"
    # kiro-cli は steering/ 以下の AGENTS.md を常に読み込む
    symlink instructions.md "${HOME}/.kiro/steering/AGENTS.md"
}
