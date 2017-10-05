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
# output text
#
function _stdio_write_text()
{
  local message="${1}"
  shift

  if [ ${_CORE_STDIO_VERBOSITY} -gt ${_CORE_STDIO_VERBOSITY_QUIET} ]; then
    printf "${message}" $@
  fi  
}

#
# output text line
#
function _stdio_write_line()
{
  local message="${1}"
  shift

  if [ ${_CORE_STDIO_VERBOSITY} -gt ${_CORE_STDIO_VERBOSITY_QUIET} ]; then
    printf "${message}\n" $@
  fi
}

#
# output warning
#
function _stdio_write_warning()
{
  local message="${1}"
  shift

  if [ ${_CORE_STDIO_VERBOSITY} -gt ${_CORE_STDIO_VERBOSITY_VERY_QUIET} ]; then
    printf "[WARNING] ${message}\n" $@
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

  if [ ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_VERY_QUIET} ]; then
    printf "[ERROR] ${message}\n" $@
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

  if [ ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_VERY_QUIET} ]; then
    printf "[CRITICAL] ${message}\n" $@
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

  if [ ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_DEBUG} ]; then
    printf "[DEBUG] ${message}\n" $@
  fi
}

#
# output warning
#
function _stdio_write_verbose_debug()
{
  local message="${1}"
  shift

  if [ ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_VERBOSE_DEBUG} ]; then
    printf "[DEBUG] ${message}\n" $@
  fi
}

#
# set verbosity to quiet
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
# set verbosity to normal
#
function _stdio_set_verbosity_verbose()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_VERBOSE}
}

#
# set verbosity to normal
#
function _stdio_set_verbosity_very_verbose()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_VERY_VERBOSE}
}

#
# set verbosity to normal
#
function _stdio_set_verbosity_debug()
{
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_DEBUG}
}

#
# write dependency loaded debug text
#
_stdio_write_dependency_load "${BASH_SOURCE[0]}"
