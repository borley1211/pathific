# vim: ft=zsh
_list() {
  __list() {
    echo $1,$2
  }

  parse_linkfiles __list

  unset -f __list $0
}
