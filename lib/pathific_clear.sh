# vim:ft=zsh
_clear() {

  __clear() { #{{{
    local orig
    
    orig="$2"

    if [ -L "${orig}" ]; then
      unlink "${orig}"
      echo "$(prompt 1 unlink)${orig}"
    fi
  } #}}}

  parse_linkfiles __clear

  unset -f __clear $0
}
