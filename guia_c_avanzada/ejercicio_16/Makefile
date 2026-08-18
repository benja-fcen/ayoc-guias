CC = gcc
CFLAGS = -Wall -Wextra -pedantic -MMD -MP
_TARGET = main

SRCS = main.c list.c type.c
OBJDIR = obj
OUTDIR = out

OBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(SRCS))
TARGET = $(patsubst %,$(OUTDIR)/%,$(_TARGET))

all: $(TARGET)

run: $(TARGET)
	@$(OUTDIR)/$(_TARGET)

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
