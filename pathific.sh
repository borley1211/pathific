# vim: ft=zsh
# pathific - PATH management framework

# Version:    0.1.0
# Repository: https://github.com/borley1211/pathific
# Author:     borley (Kazuma Miebori)
# License:    MIT

PATHIFIC_SCRIPT_ROOTDIR="$(builtin cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")" && builtin pwd)"
readonly PATHIFIC_SCRIPT_ROOTDIR
export PATHIFIC_SCRIPT_ROOTDIR

pathific_main() {
    pathific_usage() { #{{{
        cat << EOF
$PATHIFIC_COMMAND - Simplest PATH manager

Usage: $PATHIFIC_COMMAND [options] <commands> [<args>]
    $PATHIFIC_COMMAND (set | update) [-i | --ignore] [-f | --force] [-b | --backup] [-v | --verbose]
    $PATHIFIC_COMMAND add (<file> [$PATHIFIC_DIR/path/to/the/file]) | <symboliclinks>...
    $PATHIFIC_COMMAND clear
    $PATHIFIC_COMMAND (-h | --help)

Commands:
    list    Show the list which files will be managed by $PATHIFIC_COMMAND.
    check   Check the files are correctly linked to the right places.
    set     Set the symbolic links interactively.
    update  Combined command of 'pull' and 'set' commands.
    add     Move the file to the PATH directory and make its symbolic link to that place.
    edit    Edit pathificlink file.
    clear   Remove the all symbolic links in 'pathificlink'.
    config  Edit (or create if it does not exist) rcfile 'pathificrc'.

Options:
    -h, --help      Show this help message.
    -H, --help-all  Show man page.
    -c <file>, --config <file>
                Specify the configuration file to load.
                default: \$HOME/.config/pathific/pathificrc

EOF

    } #}}}

    # Option handling {{{
    local arg
    for arg in "$@"; do
        shift
        case "$arg" in
        "--help") set -- "$@" "-h" ;;
        "--help-all") set -- "$@" "-H" ;;
        "--config") set -- "$@" "-c" ;;
        *)        set -- "$@" "$arg" ;;
        esac
    done

    OPTIND=1
    local pathificrc
    while getopts "c:hH" OPT
    do
        case $OPT in
        "c")
            pathificrc="$OPTARG"
        ;;
        "h")
            pathific_usage
            unset -f pathific_usage
            return 0
        ;;
        "H")
            man "${PATHIFIC_SCRIPT_ROOTDIR}/doc/pathific.1"
            unset -f pathific_usage
            return 0
        ;;
        * )
            pathific_usage
            unset -f pathific_usage
            return 1
            ;;
        esac
    done

    shift $((OPTIND-1))
    # }}}

    # Load common.sh {{{
    source "$PATHIFIC_SCRIPT_ROOTDIR/lib/common.sh"
    trap cleanup_namespace EXIT
    # }}}

    # main command handling {{{
    case "$1" in
        clone|pull|update|list|check|set|add|edit|unlink|clear|config|cd)
            subcommand="$1"
            source "$PATHIFIC_SCRIPT_ROOTDIR/lib/pathific_${subcommand}.sh"
            shift 1
            pathific_${subcommand} "$@"
        ;;
        *)
            echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
            echo "command $(tput bold)$1$(tput sgr0) not found."
            return 1
        ;;
    esac

    # }}}

}

eval "alias ${PATHIFIC_COMMAND:="pathific"}=pathific_main"
export PATHIFIC_COMMAND
