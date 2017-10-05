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
# print the current user identification number
#
function _user_euid()
{
	echo ${EUID}
}

#
# check if current user is root (EUID === 0)
#
function _user_is_root()
{
  test $(_user_euid) -eq 0 && return ${_CORE_PREVILEGES_RET_OK} || return ${_CORE_PREVILEGES_RET_ER}
}

#
# check if current user is not root (EUID !== 0)
#
function _user_is_not_root()
{
  test $(_user_euid) -ne 0 && return ${_CORE_PREVILEGES_RET_OK} || return ${_CORE_PREVILEGES_RET_ER}
}

#
# error if user is not root
#
function _user_require_root()
{
  _user_is_root

  if [ $? -eq ${_CORE_PREVILEGES_RET_ER} ]; then
	  _stdio_write_critical ${_CORE_PREVILEGES_RET_ER} \
	  	'This action MUST be run with elevated privileges (detected "%d" user id). You may use "sudo" or other privilege escalation tools to do so.' \
	  	$(_user_euid)
  fi
}

#
# error if user is root
#
function _user_require_not_root()
{
  _user_is_not_root

  if [ $? -eq ${_CORE_PREVILEGES_RET_ER} ]; then
	  _stdio_write_critical ${_CORE_PREVILEGES_RET_ER} \
	  	'This action MUST be run with non-elevated privileges (detected "%d" user id). You must not use "sudo" or other privilege escalation tools' \
	  	$(_user_euid)
  fi
}

#
# write dependency loaded debug text
#
_stdio_write_dependency_load "${BASH_SOURCE[0]}"
