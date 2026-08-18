#!/usr/bin/env python3
import os
import sys

outdir = "out"
objdir = "obj"
prefix = "ejercicio_"
n = 1
ignore = [];
content = """#include <stdio.h>

int main() {
    printf("Hello world\\n");
    return 0;
}"""

make_content = """CC = gcc
CFLAGS = -Wall -Wextra -pedantic -MMD -MP
_TARGET = main

SRCS = main.c
OBJDIR = obj
OUTDIR = out

OBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(SRCS))
TARGET = $(patsubst %,$(OUTDIR)/%,$(_TARGET))

all: makedirs $(TARGET)

run: $(TARGET)
	$(OUTDIR)/$(_TARGET)

valgrind: $(TARGET)
	valgrind $(OUTDIR)/$(_TARGET)

$(_TARGET): % : $(OUTDIR)/%

makedirs:
	mkdir -p $(OUTDIR)
	mkdir -p $(OBJDIR)

$(TARGET): $(OBJS)
	@mkdir -p $(OUTDIR)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJDIR)/%.o: %.c
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

-include (OBJS:.o=.d)

clean:
	rm -f $(OBJDIR)/*.o $(TARGET) $(OBJDIR)/*.d

.PHONY: all clean makedirs $(_TARGET)
"""

validOptions = ['file', 'folder']

if(len(sys.argv) < 1 or not sys.argv[1] in validOptions):
    print("Error, se debe llamar con las opciones")

for i in range(2, len(sys.argv)):
    ignore.append(int(sys.argv[i]))


def makePath(fname, count):
    return fname + str(count)

def makeSource(fname, count):
    return fname + str(count) + ".c"

while(os.path.exists(makeSource(prefix, n)) or os.path.exists(makePath(prefix, n)) or n in ignore):
    n = n + 1

operation = sys.argv[1]

if(operation == 'file'):
    file = open(makeSource(prefix, n), 'a')
    file.write(content)
    file.close

if(operation == 'folder'):
    path = makePath(prefix, n)
    os.makedirs(path)
    file = open(os.path.join(path, 'main.c'), 'a')
    file.write(content)
    file.close
    file = open(os.path.join(path, "Makefile"), 'a')
    file.write(make_content)
    file.close
    os.makedirs(os.path.join(path, outdir))
    os.makedirs(os.path.join(path, objdir))

