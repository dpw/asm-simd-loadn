loadn: main.c loadn.s
	gcc -m32 -Wall -g $^ -o $@
