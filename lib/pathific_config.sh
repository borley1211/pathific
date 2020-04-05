# vim: ft=zsh
_config() {
  # init
  if [ ! -e "${pathificrc}" ]; then
    echo "$(prmpt 1 error)$(bd_ ${pathificrc}) doesn't exist."
    if __confirm y "make configuration file ? "; then
      printf "mkdir -p ${pathificrc//pathificrc} ... "
      mkdir -p "${pathificrc//pathificrc}"
      if [ -d "${pathificrc//pathificrc}" ]; then echo "$(grn_ Success.)"; else echo "$(rd_ Failure. Aborted.)"; return 1; fi
      printf "cp ${DOT_SCRIPT_ROOTDIR}/examples/pathificrc ${pathificrc} ... "
      cp "${DOT_SCRIPT_ROOTDIR}/examples/pathificrc" "${pathificrc}"
      if [ -e "${pathificrc}" ]; then echo "$(grn_ Success.)"; else echo "$(rd_ Failure. Aborted.)"; return 1; fi
    else
      echo "Aborted."; return 1
    fi
  fi

  # open pathificrc file
  if [ ! "${_edit_default_editor}" = "" ];then
    eval ${_edit_default_editor} "${pathificrc}"
  elif hash "$EDITOR"; then
    $EDITOR "${pathificrc}"
  else
    xdg-open "${pathificrc}"
  fi

  unset -f $0
}
