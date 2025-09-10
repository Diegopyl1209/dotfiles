# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.


if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# PROMPT -----
shopt -s promptvars

ESC=$'\e'

BLUE="\[${ESC}[34m\]"
GREEN="\[${ESC}[32m\]"
RED="\[${ESC}[31m\]"
YELLOW="\[${ESC}[33m\]"
RESET="\[${ESC}[0m\]"

__git_branch() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
    if [ -n "$branch" ]; then
      echo " (${branch})"
    fi
  fi
}

__bash_prompt() {
  local st=$?
  local color
  if [ $st -eq 0 ]; then color=$GREEN; else color=$RED; fi
  PS1="${BLUE}\w${YELLOW}$(__git_branch)\n${color}\$${RESET} "
}

PROMPT_COMMAND=__bash_prompt

# ----- PROMPT




