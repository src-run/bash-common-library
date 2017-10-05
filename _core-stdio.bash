#!/bin/bash

##
## This file is part of the `src-run/bash-core-library` project.
##
## (c) https://github.com/src-run/bash-core-library/graphs/contributors
##
## For the full copyright and license information, please view the LICENSE.md
## file that was distributed with this source code.
##

#
# set verbosity to none
#
function _stdio_set_verbosity_none()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_NONE}
}

#
# set verbosity to very quiet
#
function _stdio_set_verbosity_very_quiet()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_VERY_QUIET}
}

#
# set verbosity to quiet
#
function _stdio_set_verbosity_quiet()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_QUIET}
}

#
# set verbosity to normal
#
function _stdio_set_verbosity_normal()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_NORMAL}
}

#
# set verbosity to verbose
#
function _stdio_set_verbosity_verbose()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_VERBOSE}
}

#
# set verbosity to very verbose
#
function _stdio_set_verbosity_very_verbose()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_VERY_VERBOSE}
}

#
# set verbosity to debug
#
function _stdio_set_verbosity_debug()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_DEBUG}
}

#
# set verbosity to verbose debug
#
function _stdio_set_verbosity_verbose_debug()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_VERBOSE_DEBUG}
}

#
# is verbosity none
#
function _stdio_is_verbosity_none()
{
  test ${_CORE_STDIO_VERBOSITY} -le ${_CORE_STDIO_VERBOSITY_NONE} && \
    return ${_CORE_STDIO_RET_OK} || \
    return ${_CORE_STDIO_RET_ER}
}

#
# is verbosity very quiet
#
function _stdio_is_verbosity_very_quiet()
{
  test ${_CORE_STDIO_VERBOSITY} -le ${_CORE_STDIO_VERBOSITY_VERY_QUIET} && \
    return ${_CORE_STDIO_RET_OK} || \
    return ${_CORE_STDIO_RET_ER}
}

#
# is verbosity quiet
#
function _stdio_is_verbosity_quiet()
{
  test ${_CORE_STDIO_VERBOSITY} -le ${_CORE_STDIO_VERBOSITY_QUIET} && \
    return ${_CORE_STDIO_RET_OK} || \
    return ${_CORE_STDIO_RET_ER}
}

#
# is verbosity normal
#
function _stdio_is_verbosity_normal()
{
  test ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_NORMAL} && \
    return ${_CORE_STDIO_RET_OK} || \
    return ${_CORE_STDIO_RET_ER}
}

#
# is verbosity verbose
#
function _stdio_is_verbosity_verbose()
{
  test ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_VERBOSE} && \
    return ${_CORE_STDIO_RET_OK} || \
    return ${_CORE_STDIO_RET_ER}
}

#
# is verbosity very verbose
#
function _stdio_is_verbosity_very_verbose()
{
  test ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_VERY_VERBOSE} && \
    return ${_CORE_STDIO_RET_OK} || \
    return ${_CORE_STDIO_RET_ER}
}

#
# is verbosity debug
#
function _stdio_is_verbosity_debug()
{
  test ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_DEBUG} && \
    return ${_CORE_STDIO_RET_OK} || \
    return ${_CORE_STDIO_RET_ER}
}

#
# is verbosity verbose debug
#
function _stdio_is_verbosity_verbose_debug()
{
  test ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_VERBOSE_DEBUG} && \
    return ${_CORE_STDIO_RET_OK} || \
    return ${_CORE_STDIO_RET_ER}
}

#
# output section prefix
#
function _stdio_write_prefix()
{
  local char="${1}"
  local type="${2}"

  if ! _stdio_is_verbosity_none; then
    echo -en "${char}${char} [${type^^}] "
  fi
}

#
# output section prefix
#
function _stdio_write_prefix_debug()
{
  local char="${1}"
  local type="${2}"
  local size="${3:-1}"

  if _stdio_is_verbosity_none; then
    return
  fi

  echo -en "${char}${char}"
  printf ' [%s-%d] ' "${type^^}" "${size}"
}

#
# output text
#
function _stdio_write_text()
{
  local message="${1}"
  shift

  if ! _stdio_is_verbosity_none; then
    printf "${message}" "$@"
  fi  
}

#
# output text line
#
function _stdio_write_line()
{
  local message="${1}"
  shift

  if ! _stdio_is_verbosity_none; then
    printf "${message}\n" "$@"
  fi
}

#
# output warning
#
function _stdio_write_note()
{
  local message="${1}"
  shift
  local replacements="$@"

  if _stdio_is_verbosity_normal; then
    _stdio_write_prefix '-' 'note' && _stdio_write_line "${message}" "$@"
  fi
}

#
# output warning
#
function _stdio_write_warning()
{
  local message="${1}"
  shift

  if ! _stdio_is_verbosity_very_quiet; then
    _stdio_write_prefix '*' 'warn' && _stdio_write_line "${message}" "$@"
  fi
}

#
# output error
#
function _stdio_write_error()
{
  local message="${1:-An unidentified error occured}"
  shift

  if [ "${exitCode}" == "x" ]; then
    exitCode=${_CORE_STDIO_RET_ER}
  fi

  if ! _stdio_is_verbosity_none || _stdio_is_verbosity_normal; then
    _stdio_write_prefix '!' 'err ' && _stdio_write_line "${message}" "$@"
  fi
}

#
# output error
#
function _stdio_write_critical()
{
  local exitCode="${1:-null}"
  shift
  local message="${1:-An unidentified error occured}"
  shift
 
  if [ "${exitCode}" == "null" ]; then
    exitCode=${_CORE_STDIO_RET_ER}
  fi

  if ! _stdio_is_verbosity_none; then
    _stdio_write_prefix '#' 'crit' && _stdio_write_line "${message}" "$@"
  fi

  exit ${exitCode}
}

#
# output warning
#
function _stdio_write_debug()
{
  local message="${1}"
  shift

  if _stdio_is_verbosity_very_verbose; then
    _stdio_write_prefix_debug '-' 'debug' 1 && _stdio_write_line "${message}" "$@"
  fi
}

#
# output warning
#
function _stdio_write_verbose_debug()
{
  local message="${1}"
  shift

  if _stdio_is_verbosity_debug; then
    _stdio_write_prefix_debug '-' 'debug' 2 && _stdio_write_line "${message}" "$@"
  fi
}

#
# output warning
#
function _stdio_write_very_verbose_debug()
{
  local message="${1}"
  shift

  if _stdio_is_verbosity_verbose_debug; then
    _stdio_write_prefix_debug '-' 'debug' 3 && _stdio_write_line "${message}" "$@"
  fi
}

#
# output dependency loaded verbose debug information
#
function _core_dependency_loaded()
{
  local full="${1}"
  local path="$(cd "$(dirname "${full}")" && pwd)"
  local base="$(basename "${full}" ".bash")"
  local name="${base:6}"

  _stdio_write_verbose_debug 'Sourced "%s" core dependency at "%s"' ${name} "${path}/${base}.bash"
}

#
# write dependency loaded debug text
#
_core_dependency_loaded "${BASH_SOURCE[0]}"
