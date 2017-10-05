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
  if [ ${#_DEPS_NAMED[@]} -eq 0 ]; then
    return
  fi

  local path=""
  local real=""
  local okay=0

  for name in "${_DEPS_NAMED[@]}"; do
    for root in "${_CORE_DEPENDENCY_ROOTS[@]}"; do
      for format in "${_CORE_DEPENDENCY_PATHS[@]}"; do
        path="$(printf "${root}${format}" "${name}" "${name}")"
        real="$(realpath "${path}" 2> /dev/null)"

        if [ -f "${real}" ]; then
          _stdio_write_debug 'Runtime dependency "%s" resolved to "%s"...' ${name} "${real}"
          _DEPS_RESOLVED[${name}]="${real}"
          okay=1
          break 2
        fi

        _stdio_write_verbose_debug 'Runtime dependency "%s" NOT resolved to "%s"...' ${name} "${path}"
      done
    done

    if [ ${okay} -eq 0 ]; then
      _stdio_write_error 'Failed resolving runtime dependency "%s"!' ${name}
    fi

    okay=0
  done
}

#
# write dependency loaded debug text
#
_stdio_write_dependency_load "${BASH_SOURCE[0]}"

#
# handle auto dependency resolution
#
if [ ${_CORE_DEPENDENCY_AUTO} -eq 1 ]; then
  _dependencies_resolve_paths
fi
