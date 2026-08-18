CC = gcc
CFLAGS = -Wall -Wextra -pedantic
VALGRIND = valgrind

define \n


endef

DONT_CREATE = 3 18

_DONT_COMPILE = 5 11 20
DONT_COMPILE = $(patsubst %,ejercicio_%.c, $(_DONT_COMPILE))

SUBDIRS = $(wildcard ejercicio_*/.)

_SRC = $(wildcard *.c)
SRC = $(filter-out $(DONT_COMPILE), $(_SRC))

OBJDIR = obj
OBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(SRC))

OUTDIR = out

TARGET = $(patsubst %.c,$(OUTDIR)/%,$(SRC))
_TARGET = $(subst .c,,$(SRC))
SUBDIR_TARGET = $(subst /.,,$(SUBDIRS))

RUN = $(subst ejercicio_,run,$(_TARGET))
SUBDIR_RUN = $(subst ejercicio_,run,$(SUBDIR_TARGET))
RUN_VALGRIND = $(subst ejercicio_,valgrind,$(_TARGET))
SUBDIR_RUN_VALGRIND = $(subst ejercicio_,valgrind,$(SUBDIR_TARGET))

all: $(TARGET) $(SUBDIRS)

makedirs:
	mkdir -p $(OBJDIR)
	mkdir -p $(OUTDIR)

$(SUBDIR_TARGET): % : %/.

$(SUBDIRS):
	$(MAKE) --no-print-directory -C $@

$(_TARGET) : % : $(OUTDIR)/%
	
$(TARGET): $(OUTDIR)/% : $(OBJDIR)/%.o
	@mkdir -p $(OUTDIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJDIR)/%.o : %.c
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(RUN): run% : ejercicio_%
	$(OUTDIR)/$<

$(SUBDIR_RUN) : run% : ejercicio_%
	$(MAKE) --no-print-directory -C $</. run;

$(RUN_VALGRIND) : valgrind% : ejercicio_%
	valgrind $(OUTDIR)/$<

$(SUBDIR_RUN_VALGRIND) : valgrind% : ejercicio_%
	$(MAKE) --no-print-directory -C $</. valgrind;

nextFile:
	python3 ../next.py file $(DONT_CREATE)

nextFolder:
	python3 ../next.py folder $(DONT_CREATE)

clean:
	-rm -f $(OBJDIR)/*.o $(OUTDIR)/ejercicio_*
	-$(foreach f,$(SUBDIRS),$(MAKE) --no-print-directory -C $(f) clean ${\n})

.PHONY: all clean nextFile nextFolder makedirs $(SUBDIR_RUN) $(RUN) $(_TARGET) $(SUBDIRS) $(SUBDIR_TARGET)