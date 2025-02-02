if [[ -z $HARBONIZER_BASHRC ]]; then
	cat $PWD/bash/bashrc
	echo 'export HARBONIZER_BASHRC=1'
fi
