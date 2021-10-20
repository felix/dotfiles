#!/bin/sh

here=$PWD

for r in $(find . -type d -exec test -e '{}/.git' ';' -print -prune); do
	cd "$r"
	git diff-index --quiet --cached HEAD -- >/dev/null
	[ $? ] || printf 'staged: %s\n' "$r"
	git diff-files --quiet >/dev/null
	[ $? ] || printf 'unstaged: %s\n' "$r"
	test -z "$(git ls-files --exclude-standard --others)" || printf 'untracked: %s\n' "$r"
	cd "$here"
done
