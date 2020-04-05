# vim: ft=zsh
_update() {
  source "$DOT_SCRIPT_ROOTDIR/lib/pathific_pull.sh"
  source "$DOT_SCRIPT_ROOTDIR/lib/pathific_set.sh"
  _pull
  _set $@

  unset -f $0
}
