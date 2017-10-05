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
# resolve the dependency paths and assign them to resolved global variable
#
function _dependencies_resolve_paths()
{
  local path=""
  local real=""
  local ok=0

  if [ ${#_DEPS_NAMED[@]} -eq 0 ]; then
    return
  fi

  for name in "${_DEPS_NAMED[@]}"; do
    for root in "${_CORE_DEPENDENCY_ROOTS[@]}"; do
      for format in "${_CORE_DEPENDENCY_PATHS[@]}"; do
        path="$(printf "${root}${format}" "${name}" "${name}")"
        real="$(realpath "${path}" 2> /dev/null)"

        if [ -f "${real}" ]; then
          _stdio_write_debug 'Resolved the "%s" runtime dependency to "%s"' ${name} "${real}"
          _DEPS_RESOLVED[${name}]="${real}"
          ok=1
          break 2
        else
          _stdio_write_very_verbose_debug 'Searched for "%s" runtime dependency in "%s"' ${name} "${path}"
        fi
      done
    done

    if [ ${ok} -ne 1 ]; then
      _stdio_write_error 'Failure resolving "%s" runtime dependency' ${name}
    fi

    ok=0
  done

  local sizeNamed=${#_DEPS_NAMED[@]}
  local sizeResolved=${#_DEPS_RESOLVED[@]}

  if [ ${sizeNamed} -ne ${sizeResolved} ]; then
    _stdio_write_critical ${_CORE_DEPENDENCIES_RET_ER} \
      'Resolved %d of %d runtime dependencies (%d unsuccessful): exiting due to prior failure(s)...' \
      ${sizeResolved} ${sizeNamed} $(((${sizeNamed} - ${sizeResolved})))
  fi
}

#
# write dependency loaded debug text
#
_core_dependency_loaded "${BASH_SOURCE[0]}"
