# Implement a csh-like directory stack in ksh
#
# environment variable dir_stack contains all directory entries except
# the current directory

unset dir_stack
export dir_stack


# Three forms of the pushd command:
#    pushd        - swap the top two stack entries
#    pushd +3     - swap top stack entry and entry 3 from top
#    pushd newdir - cd to newdir, creating new stack entry

function pushd {
	sd=${#dir_stack[*]}  # get total stack depth
	if [ $1 ] ; then
		if [ ${1#\+[0-9]*} ] ; then
			# ======= "pushd dir" =======

			# is "dir" reachable?
			if [ `(cd $1) 2>/dev/null; echo $?` -ne 0 ] ; then
				cd $1               # get the actual shell error message
				return 1            # return complaint status
			fi

			# yes, we can reach the new directory; continue

			(( sd = sd + 1 ))      # stack gets one deeper
			dir_stack[sd]=$PWD
			cd $1
			# check for duplicate stack entries
			# current "top of stack" = ids; compare ids+dsdel to $PWD
			# either "ids" or "dsdel" must increment with each loop
			#
			(( ids = 1 ))          # loop from bottom of stack up
			(( dsdel = 0 ))        # no deleted entries yet
			while [ ids+dsdel -le sd ] ; do
				if [ "${dir_stack[ids+dsdel]}" = "$PWD" ] ; then
					(( dsdel = dsdel + 1 ))  # logically remove duplicate
				else
					if [ dsdel -gt 0 ] ; then        # copy down
						dir_stack[ids]="${dir_stack[ids+dsdel]}"
					fi
					(( ids = ids + 1 ))
				fi
			done

			# delete any junk left at stack top (after deleting dups)

			while [ ids -le sd ] ; do
				 unset dir_stack[ids]
				 (( ids = ids + 1 ))
			done
			unset ids
			unset dsdel
		 else
			 # ======= "pushd +n" =======
			 (( sd = sd + 1 - ${1#\+} ))    # Go 'n - 1' down from the stack top
			 if [ sd -lt 1 ] ; then (( sd = 1 )) ; fi
			 cd ${dir_stack[sd]}            # Swap stack top with +n position
			 dir_stack[sd]=$OLDPWD
		fi
	else
		#    ======= "pushd" =======
		# swap only if there's a value to swap with
		if [ ${#dir_stack[*]} = "0" ]; then
			echo "ksh: pushd: no other directory" >&2
		else
			cd ${dir_stack[sd]}       # Swap stack top with +1 position
			dir_stack[sd]=$OLDPWD
		fi
	fi
}

function popd {
	sd=${#dir_stack[*]}
	if [ $sd -gt 0 ] ; then
		cd ${dir_stack[sd]}
		unset dir_stack[sd]
	else
		cd ~
	fi
}

function dirs {
	echo "0: $PWD"
	sd=${#dir_stack[*]}
	(( ind = 1 ))
	while [ $sd -gt 0 ]
	do
		echo "$ind: ${dir_stack[sd]}"
		(( sd = sd - 1 ))
		(( ind = ind + 1 ))
	done
}
