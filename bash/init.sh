if [[ "$0" == "/usr/bin/lua-any" && $HARBONIZER_BASHRC ]]; then
	cat $HARBONIZER/bash/bashrc
	echo 'unset HARBONIZER_BASHRC'
fi
