
CC = gcc
LD = gcc
DEP = gcc -M
RM = rm -rf
DEPS = depend

ORIG_CC := $(CC)
CC = @echo CC $<; $(ORIG_CC)
ORIG_AS := $(AS)
AS = @echo AS $<; $(ORIG_AS)
ORIG_LD := $(LD)
LD = @echo LD $@; $(ORIG_LD)
ORIG_DEP := $(DEP)
DEP = @echo DEP $@; $(ORIG_DEP)

CFLAGS = -Wall -g

INCLUDE = -I/usr/include/CUnit
LIB = -llibcunit

SRC = $(FILE).c

OBJS = $(SRC:.c=.o)

PROG = tests

$(PROG): main.o $(OBJS)
	$(LD) $(LFLAGS) -o $@ $^ $(LIB)


main.o: main.c

main.c:
	cp -f main.skel main.tmp;       \
		sed 's/arg/$(FILE)/g' < main.tmp > main.c; \
		rm -f main.tmp ;\
	$(CC) -c $(CFLAGS) -o $@ $<

PHONY: clean cleandep allclean


allclean: clean cleandep

clean:
	$(RM) *.o *.exe main.c

cleandep:
	$(RM) depend

$(DEPS): $(SRC)
	$(DEP) -M $(SRC) > $(DEPS)

ifeq ($(findstring clean, $(MAKECMDGOALS)),)
-include $(DEPS)
endif

