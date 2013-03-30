test8: test8.c loadn8.s
	gcc -m32 -Wall -g $^ -o $@

,PHONY: clean
clean::
	rm -f test8
