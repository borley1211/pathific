# vim:ft=zsh
_add() {
  # default message
  local message=""

  # option handling
  while getopts m:h OPT; do
    case $OPT in
    "m") message="${OPTARG}";;
    esac
  done

  shift $((OPTIND - 1))

  if [ !  -e "$1" ]; then
    echo "$(prmpt 1 error)$(bd_ $1) doesn't exist."
    return 1
  fi

  orig_to_pathific() {
    # mv from original path to pathificdir
    local orig pathific

    orig="$(get_fullpath "$1")"
    pathific="$(get_fullpath "$2")"

    mv -i "${orig}" "${pathific}"

    # link to orig path from pathificfiles
    ln -siv "${pathific}" "${orig}"
  }

  add_to_Pathfile() {
    local pathificfile linkto
    # add the configration to the config file.
    [ -n "${message}" ] && echo "# ${message}" >> "${Pathfile}"

    pathificfile="$(path_without_pathificdir "$2")"
    if [ "${pathificfile}" = "" ] ; then
      pathificfile="$(path_without_home "$2")"
      if [[ -n ${pathificfile} ]] ; then
        pathificfile="\$HOME/${pathificfile}"
      else
        pathificfile="$(get_fullpath "$2")"
      fi
    fi

    linkto="$(path_without_home "$1")"
    linkto="${linkto:="$(get_fullpath "$1")"}"

    echo "${pathificfile},${linkto}" >> "${Pathfile}"

    if $?; then
      echo "Successfully added the new file to pathificfiles"
      echo "To edit the links manually, execute \`${PATHIFIC_COMMAND} edit\`"
    fi
  }

  if_islink() {
    # write to Pathfile
    local f abspath

    for f in "$@"; do
      if [ ! -L "$f" ]; then
        echo "$(prmpt 1 error) $(bd_ "$1") is not the symbolic link."
        continue
      fi

      # get the absolute path
      abspath="$(readlink "$f")"

      if [ ! -e "${abspath}" ]; then
        echo - n "$(prmpt 1 error)Target path $(bd_ ${abspath}) doesn't exist."
        return 1
      fi

      # write to Pathfile
      add_to_Pathfile "$f" "${abspath}"
    done
  }

  suggest() {
    echo "$(prmpt 6 suggestion)"
    echo "    pathific add -m '${message}' $1 ${pathificdir}/$(path_without_home "$1")"
    _confirm n "Continue? " || return 1

    _add_main "$1" "${pathificdir}/$(path_without_home $1)"
  }

  check_dir() {
    if [ -d "${1%/*}" ]; then
      return 0
    fi

    echo "$(prmpt 1 error)$(bd_ ${1%/*}) doesn't exist."
    if __confirm y "make directory $(bd_ ${1%/*}) ? "; then
      mkdir -p "${1%/*}"
      return 0
    fi

    return 1
  }

  _add_main() {
    # if the first arugument is a symbolic link
    if [ -L "$1" ]; then
      if_islink "$@" || return 1
      return 0
    fi

    # if the second arguments is provided (default action)
    if [ $# = 2 ]; then

      # if the targeted directory doesn't exist,
      # ask whether make directory or not.
      check_dir "$2" || return 1

      orig_to_pathific "$1" "$2"
      add_to_Pathfile "$1" "$2"

      return 0
    fi

    # if the second arugument isn't provided, provide suggestion
    if [ $# = 1 ]; then
      suggest "$1" && return 0 || return 1
    fi

    # else
    echo "$(prmpt 1 error)Aborted."
    echo "Usage: 'pathific add file'"
    echo "       'pathific add file ${pathificdir}/any/path/to/the/file'"

    return 1
  }

  _add_main "$@"

  unset -f orig_to_pathific add_to_Pathfile if_islink suggest check_dir
  unset -f "$0"
}
