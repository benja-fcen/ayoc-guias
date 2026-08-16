CC = gcc
CFLAGS = -Wall -Wextra -pedantic -MMD -MP
_TARGET = binario

SRCS = funca.c funcb.c main.c
OBJDIR = obj
OUTDIR = out

OBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(SRCS))
TARGET = $(patsubst %,$(OUTDIR)/%,$(_TARGET))

all: makedirs $(TARGET)

run:
	@$(OUTDIR)/$(_TARGET)

makedirs:
	mkdir -p $(OBJDIR)
	mkdir -p $(OUTDIR)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

-include (OBJS:.o=.d)

clean:
	rm -f $(OBJDIR)/*.o $(TARGET) $(OBJDIR)/*.d

.PHONY: all clean makedirs