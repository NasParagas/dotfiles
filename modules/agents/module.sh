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

    # skill はディレクトリごとにリンクする。
    # テンプレートの拡張子を .tmpl にしているのは、ここで作業するときに
    # templates/AGENTS.md がこのリポジトリの規約として読まれないようにするため。
    symlink_module_dir_contents skills "${HOME}/.claude/skills"
    # Codex のユーザー単位の skill の置き場所。opencode も ~/.claude/skills と合わせてここを読む
    symlink_module_dir_contents skills "${HOME}/.agents/skills"
    # kiro-cli の既定のエージェントはここを読む。カスタムエージェントでは resources への追加が必要
    symlink_module_dir_contents skills "${HOME}/.kiro/skills"
}
