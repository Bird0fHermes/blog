# todo.sh, a small bash script to maintain a to-do list
# Copyright (C) 2020  Max Briggs
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

#!/bin/bash

TOMORROW=$(date -d "+1 day" +%F)

if [[ -z "$1" ]]; then
	if tac $TODO | grep -qm 1 $TOMORROW; then
		:
	else
		echo $TOMORROW >> $TODO
	fi
	$EDITOR $TODO
elif [[ "$1" = "-a" && -z "$2" ]]; then
	$EDITOR $TODO
elif [[ "$1" = "-a" ]]; then
	echo -e "\t$2" >> $TODO
elif [[ "$1" = "-c" ]]; then
	let lines=$(grep -n $(date +%F) $TODO | gawk '{print $1}' FS=":")-$(wc -l $TODO | gawk '{print $1}')-1
	tail -n $lines $TODO
elif [[ "$1" = "-h" ]]; then
	echo "Usage: todo [OPTION] [MESSAGE]...
Edit or print todo file.

With no MESSAGE, execute EDITOR.

  -a	Append to TODO without date
  -c      Concatenate TODO
  -h      Show this message

Examples:
  todo             Append to TODO and add date
  todo -a          Append to TODO
  todo -a example  Append "example" to TODO"
else
	echo "$TOMORROW $1" >> $TODO
fi
