# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

#==============================================================================
#
# command-line parsing module
#
#==============================================================================


function cmdl_init
{ $_FNPROLOG
  CMDLINE=( "$@" )
  CMDLINE_ERRORS=''
}

function cmdl_error
{ $_FNPROLOG
  printf "ERROR: %s\n" "$*" 1>&2
  unset OPT
  unset OPTARG
  CMDLINE_ERRORS=y
}

function cmdl_dieIfErrors
{ $_FNPROLOG
  if [[ -n "${CMDLINE_ERRORS-}" ]] ; then
    fatal "Command-line parsing errors, cannot continue."
  fi
}

function cmdl_getOpt
{ $_FNPROLOG
  typeset shortOpts="$1" longOpts=",$2,"
  typeset tt=( 1 )
  typeset IDX1="${tt[1]-0}"
  typeset rest optStr

  unset OPT
  unset OPTARG

  if ! [[ "${#CMDLINE[@]}" -gt 0 ]] ; then
    return 1
  fi

  case "${CMDLINE[$IDX1]}" in

  --) # End of options marker
    CMDLINE=( "${CMDLINE[@]:1}" )
    return 1
    ;;


  --*)  # double-dash argument
    OPT="${CMDLINE[$IDX1]}"
    CMDLINE=( "${CMDLINE[@]:1}" )

    if [[ "$OPT" == *=* ]] ; then
      OPTARG="${OPT#*=}"
      OPT="${OPT%%=*}"
    fi
    optStr="${OPT#--}"

    case "$longOpts" in
      *",$optStr=,"*) # Optional argument (specified with =)
        # OPTARG already set above if needed
        ;;
      *",$optStr:,"*) # Mandatory argument (specified with = or as following item)
        if [[ -z "${OPTARG+x}" ]] ; then
          if [[ "${#CMDLINE[@]}" -gt 0 ]] ; then
            OPTARG="${CMDLINE[$IDX1]}"
            CMDLINE=( "${CMDLINE[@]:1}" )
          else
            cmdl_error "Option \"$OPT\" must be followed by one argument"
          fi
        fi
        ;;
      *",$optStr,"*) # No argument
        if ! [[ -z "${OPTARG+x}" ]] ; then
          cmdl_error "Option \"$OPT\" does not take an argument"
        fi
        ;;
      *)  # Invalid option
        cmdl_error "Unknown option \"$OPT\""
        ;;
    esac
    ;;


  -*) # single-dash argument
    optStr="${CMDLINE[$IDX1]}"
    optStr="${optStr:1:1}"
    OPT="-$optStr"

    rest="${CMDLINE[$IDX1]#-$optStr}"
    if [[ "$rest" == "="* ]] ; then
      OPTARG="${rest#=}"
      rest=""
    fi

    case "$shortOpts" in
      *"$optStr="*) # Optional argument (specified with =)
        # OPTARG already set above if needed
        ;;
      *"$optStr:"*) # Mandatory argument (specified with = or as following item)
        if [[ -n "${OPTARG+x}" ]] ; then
          :
        elif [[ -n "$rest" ]] ; then
          cmdl_error "Option \"$OPT\" must be followed by one argument, as \"$OPT=arg\" or as \"-OPT arg\""
          rest=""
        else
          if [[ "${#CMDLINE[@]}" -ge 2 ]] ; then
            CMDLINE=( "${CMDLINE[@]:1}" )
            OPTARG="${CMDLINE[$IDX1]}"
          else
            cmdl_error "Option \"$OPT\" must be followed by one argument"
          fi
        fi
        ;;
      *"$optStr"*) # No argument
        if [[ -n "${OPTARG+x}" ]] ; then
          cmdl_error "Option \"$OPT\" does not take an argument"
        fi
        ;;
      *) # Invalid option
        cmdl_error "Invalid option \"$OPT\""
        ;;
    esac

    if [[ -n "$rest" ]] ; then
      CMDLINE[$IDX1]="-$rest"
    else
      CMDLINE=( "${CMDLINE[@]:1}" )
    fi
    ;;


  *) # Not an option
    return 1
    ;;

  esac
    
  return 0
}
