# Return success when a command is available on PATH.
doesCommandExist() {
  command -v "$1" >/dev/null 2>&1
}

pdf() {
  /usr/bin/open "$1"
}

opdf() {
  /usr/bin/open "$1"
}

# Copy a file's contents to the macOS clipboard.
cpfile() {
  if [[ $# -ne 1 || ! -f "$1" ]]; then
    print -u2 "usage: cpfile <file>"
    return 1
  fi

  /usr/bin/pbcopy < "$1"
}

# Print piped input and copy it to the macOS clipboard.
cap() {
  tee >(/usr/bin/pbcopy)
}

# Export variables declared by a trusted shell-format environment file.
sourceenv() {
  if [[ $# -ne 1 || ! -f "$1" ]]; then
    print -u2 "usage: sourceenv <file>"
    return 1
  fi

  set -a
  source "$1"
  local source_status=$?
  set +a
  return $source_status
}

# Render a three-digit octal mode as rwx permissions.
octal() {
  if [[ $# -ne 1 || ! "$1" =~ '^[0-7]{3}$' ]]; then
    print -u2 "usage: octal <000-777>"
    return 1
  fi

  local mode="$1"
  local -a permissions
  permissions=(--- --x -w- -wx r-- r-x rw- rwx)
  print -r -- "${permissions[$((10#${mode[1]} + 1))]}${permissions[$((10#${mode[2]} + 1))]}${permissions[$((10#${mode[3]} + 1))]}"
}

fzf-git-branch() {
  git rev-parse HEAD >/dev/null 2>&1 || return

  git branch --color=always --all --sort=-committerdate |
    command grep -v HEAD |
    fzf --height 75% --ansi --no-multi --preview-window right:65% \
      --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
    sed 's/.* //'
}

gch() {
  git rev-parse HEAD >/dev/null 2>&1 || return

  local branch
  branch=$(fzf-git-branch) || return
  [[ -n "$branch" ]] || return

  if [[ "$branch" == remotes/* ]]; then
    git checkout --track "$branch"
  else
    git checkout "$branch"
  fi
}

awsExportCredentials() {
  if [[ $# -ne 1 ]]; then
    print -u2 "usage: awsExportCredentials <profile>"
    return 1
  fi

  print "Exporting credentials for profile $1"
  local exports
  exports=$(aws configure export-credentials --profile "$1" --format env) || {
    print "These are the existing profiles"
    aws configure list-profiles
    return 1
  }
  eval "$exports"
}

# Change directory according to the existing project-root helper.
pr() {
  local output
  output=$("$HOME/.proot/proot" "$@")
  local status=$?
  local action="${1:-}"

  if [[ ( "$action" == "go" || -z "$action" || "$action" == "back" || "$action" == "b" || "$action" == "to" || "$action" == "t" ) && $status -eq 0 ]]; then
    cd "$output" || return
  else
    print -r -- "$output"
  fi

  return $status
}
