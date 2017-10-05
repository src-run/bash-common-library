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
# std verbosity levels
#
_CORE_STDIO_VERBOSITY_NONE=-10
_CORE_STDIO_VERBOSITY_VERY_QUIET=-2
_CORE_STDIO_VERBOSITY_QUIET=-1
_CORE_STDIO_VERBOSITY_NORMAL=0
_CORE_STDIO_VERBOSITY_VERBOSE=1
_CORE_STDIO_VERBOSITY_VERY_VERBOSE=2
_CORE_STDIO_VERBOSITY_DEBUG=3
_CORE_STDIO_VERBOSITY_VERBOSE_DEBUG=10

#
# set stdio default verbosity
#
if [ -z ${_CORE_STDIO_VERBOSITY+x} ]; then
  _CORE_STDIO_VERBOSITY=${_CORE_STDIO_VERBOSITY_NORMAL}
fi

#
# error return integers
#
_CORE_USERS_RET_OK=0
_CORE_USERS_RET_ER=100
_CORE_STDIO_RET_OK=0
_CORE_STDIO_RET_ER=150
_CORE_DEPENDENCIES_RET_ER=120

#
# default dependency search root paths
#
if [ -z ${_CORE_DEPENDENCY_AUTOLOAD+x} ]; then
  _CORE_DEPENDENCY_AUTOLOAD=1
fi

#
# default dependency search root paths
#
if [ -z ${_CORE_DEPENDENCY_ROOTS+x} ]; then
  _CORE_DEPENDENCY_ROOTS=("./")

  if [ ! -z ${_SELF_PATH:x} ]; then
    _CORE_DEPENDENCY_ROOTS+=("${_SELF_PATH}/" "${_SELF_PATH}/lib/" "${_SELF_PATH}/inc/" "${_SELF_PATH}/scripts/")
  fi

  if [ ! -z ${HOME:x} ]; then
    _CORE_DEPENDENCY_ROOTS+=("${HOME}/scripts/lib/")
  fi

  _CORE_DEPENDENCY_ROOTS+=("/scripts/lib/" "/pool/scripts/lib/")
fi

#
# default dependency search file path formats
#
if [ -z ${_CORE_DEPENDENCY_PATHS+x} ]; then
  _CORE_DEPENDENCY_PATHS=("%s-library/%s.bash" "%s-library/%s-library.bash" "%s/%s.bash" "%s/%s-library.bash")
fi

#
# default dependency names
#
if [ -z ${_DEPS_NAMED+x} ]; then
  _DEPS_NAMED=("bright" "writer")
fi

#
# clear any previously resolved dependencies
#
declare -A _DEPS_RESOLVED

#
# output dependency loaded verbose debug information
#
function _core_dependency_loaded()
{
  local full="${1}"
  local path="$(cd "$(dirname "${full}")" && pwd)"
  local base="$(basename "${full}" ".bash")"
  local name="${base:5}"

  if [ ${_CORE_STDIO_VERBOSITY} -ge ${_CORE_STDIO_VERBOSITY_DEBUG} ]; then
    echo -en "-- " && printf '[DEBUG-2] Sourced "%s" core dependency at "%s"\n' ${name} "${path}/${base}.bash"
  fi
}

#
# write dependency loaded debug text
#
_core_dependency_loaded "${BASH_SOURCE[0]}"
