set-hook -g session-closed "run-shell 'echo \"session-closed $(tmux ls)\" >> ~/log'"
set-hook -g client-detached "run-shell 'echo \"client-detached $(tmux ls)\" >> ~/log'"
