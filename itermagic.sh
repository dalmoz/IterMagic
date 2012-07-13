#!/bin/sh

: << 'GNU-LICENSE'
 * itermagic.sh: shell script intended to  spot 'magic numbers' within
 * a binary file
 * 
 * Purpose:
 * 
 * A small ITERative MAGICnumber finder, implemented by shell scripting and
 * utilizing standard *nix software components and tools.
 * In order to evaluate binary files that are concatenated in binary files.
 * which is a common practice found in malware, for example.
 * Directed at malware analysis, originally, but it can be used against any kind
 * of binary files and file forensics.
 * 
 * Dependancies:
 * 		stat, awk, dd, file commands (and, of course, a shell)
 *
 * Authors: 
 * 		dalmoz (Moshe Zioni) [ zimoshe [at] gmail [dot] com ]
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA
GNU-LICENSE

## checking file's size
EOF=$(stat -c %s $1)
## run file command natively once
echo "NATIVE scan:"
file $1
COUNTER=1
##conditional iterations (Drop 'data')
while [ $COUNTER -lt $EOF ]; do
	dd bs=$COUNTER skip=1 if=$1 of=temp.of 2>/dev/null
	PIF=$(file temp.of)
	CHP=$(echo $PIF|awk '{for (i=2;i<NF; i++) print $i " "; print $NF}')
	if [ "$CHP" != "data" ]; then
		printf "\n0x%X: \t" $COUNTER
		echo $CHP
	fi
	let COUNTER=COUNTER+1
done
## cleanup
rm temp.of
#printf "0x%X: ",  $1
