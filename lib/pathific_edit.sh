# vim: ft=zsh
_edit() {
  # init
  if [ ! -e "${Pathfile}" ]; then
    echo "$(prmpt 1 empty)$(bd_ ${Pathfile})"
    if __confirm y "make Pathfile file ? " ; then
      echo "cp ${DOT_SCRIPT_ROOTDIR}/examples/Pathfile ${Pathfile}"
      cp "${DOT_SCRIPT_ROOTDIR}/examples/Pathfile" "${Pathfile}"
    else
      echo "Aborted."; return 1
    fi
  fi

  # open Pathfile file
  if [ -n "${_edit_default_editor}" ];then
    eval ${_edit_default_editor} "${Pathfile}"
  elif hash "$EDITOR" 2>/dev/null; then
    $EDITOR "${Pathfile}"
  else
    xdg-open "${Pathfile}"
  fi

  unset -f $0
}
