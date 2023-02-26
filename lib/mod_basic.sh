# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

#==============================================================================
#
# Basic module
#
#==============================================================================

IGNORE_FURTHER_ERRORS=

function fatal
{ $_FNPROLOG
  printf 'FATAL: %s (PID: %s)\n' "$*" "$$" 1>&2
  doExit 255
}

function DIE
{ $_FNPROLOG
  fatal "Error causing script to die: $?"
}

function success
{ $_FNPROLOG
  [[ -n "${SUCCESS:-}" ]]
}

function doExit
{ $_FNPROLOG
  IGNORE_FURTHER_ERRORS=y
  exit "$@"
}

trap '[[ -n "${IGNORE_FURTHER_ERRORS:-}" ]] || fatal "Uncaught error"' ERR


function Zgrep
{ $_FNPROLOG
  grep "$@" || true
}

function Zdiff
{ $_FNPROLOG
  diff "$@" || true
}

function Zfind
{ $_FNPROLOG
  find "$@" || true
}

function Zls
{ $_FNPROLOG
  ls "$@" || true
}

function Scat
{ $_FNPROLOG
  cat "$@" 2>/dev/null || fatal "Could not read file \"$*\""
}

function makeHeading
{ $_FNPROLOG
  sed 'h;s/./=/g;H;g'
}
