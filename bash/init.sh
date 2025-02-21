if [[ "$0" == "/usr/bin/lua-any" && -z $HARBONIZER_BASHRC ]]; then
	cat $HARBONIZER_DIR/bash/bashrc
	echo 'export HARBONIZER_BASHRC=1'
fi
