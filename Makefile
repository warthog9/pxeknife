SHELL = /bin/bash

PWD := $(shell pwd)

ABSPATH = 

.SILENT:

all: make_statement

clean: make_statement

make_statement:
	echo "Hello World!"

