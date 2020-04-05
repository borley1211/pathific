# vim:ft=zsh
_check() {

__check() {
  local pathificfile orig origdir linkto message
  local delimiter = ","
  pathificfile = "$1"
  orig = "$2"
  message = "${pathificfile}${delimiter}${orig}"

  # if pathificfile doesn't exist
    if ! [[ -e "${pathificfile}" || -e "${orig}" || -L "${orig}" ]]; then
      echo "$(prmpt 1 ✘)${message}"
      return 1
    fi

    linkto="$(readlink "${orig}")"

    if [ "${linkto}" = "${pathificfile}" ]; then
      echo "$(prmpt 2 ✔)${message}"
    else
      echo "$(prmpt 1 ✘)${message}"
    fi
    return 0
  }

  parse_linkfiles __check

  unset -f __check $0
}
