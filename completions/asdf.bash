#!/usr/bin/env bash

_asdf () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cmd=${COMP_WORDS[1]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}
  local plugins=$(asdf plugin-list | tr '\n' ' ')
  local plugdir=$HOME/.asdf-plugins/plugins

  COMPREPLY=()

  case "$cmd" in
    plugin-add)
        IFS=$'\x0a'
        local strings=$(for f in $plugdir/*; do \
            echo -n "$f " | awk -F/ '{printf $NF}' ;\
            awk 'END {print $NF}' "$f"; done)
        COMPREPLY=($(compgen -W "$strings" -- $cur))
        unset IFS
        return 0
        ;;
    plugin-update)
      COMPREPLY=($(compgen -W "$plugins --all" -- $cur))
      ;;
    plugin-remove|current|list|list-all)
      COMPREPLY=($(compgen -W "$plugins" -- $cur))
      ;;
    install)
      if [[ "$plugins" == *"$prev"* ]] ; then
        local versions=$(asdf list-all $prev)
        COMPREPLY=($(compgen -W "$versions" -- $cur))
      else
        COMPREPLY=($(compgen -W "$plugins" -- $cur))
      fi
      ;;
    uninstall|where|reshim)
      if [[ "$plugins" == *"$prev"* ]] ; then
        local versions=$(asdf list $prev)
        COMPREPLY=($(compgen -W "$versions" -- $cur))
      else
        COMPREPLY=($(compgen -W "$plugins" -- $cur))
      fi
      ;;
    *)
      local cmds='plugin-add plugin-list plugin-remove plugin-update install uninstall update current where list list-all reshim'
      COMPREPLY=($(compgen -W "$cmds" -- $cur))
      ;;
  esac

  return 0
}

complete -F _asdf asdf
