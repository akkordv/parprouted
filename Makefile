EXTRA_CFLAGS = 

PREFIX = /opt/parprouted
INITD = $(PREFIX)/init.d
#INITD = /etc/rc.d/init.d

CC = gcc-10

CFLAGS = -g -O2 -Wall $(EXTRA_CFLAGS)
# For ARM:
# CFLAGS =  -Wall $(EXTRA_CFLAGS)
OBJS = parprouted.o arp.o

LIBS = -lpthread -lresolv

all: parprouted parprouted.8 parprouted.sh

install: all
	install -d $(PREFIX)/sbin
	install parprouted $(PREFIX)/sbin
	install -d $(PREFIX)/share/man/man8
	install -m 644 parprouted.8 $(PREFIX)/share/man/man8
	install -d $(INITD)
	install parprouted.sh $(INITD)/parprouted

clean:
	rm -f $(OBJS) parprouted core parprouted.8 parprouted.sh

parprouted:	${OBJS}
	${CC} -g -o parprouted ${OBJS} ${CFLAGS} ${LDFLAGS} ${LIBS}

parprouted.8:	parprouted.pod
	pod2man --section=8 --center="Proxy ARP Bridging Daemon" parprouted.pod --release "parprouted" --date "`date '+%B %Y'`" > parprouted.8

parprouted.o : parprouted.c parprouted.h

arp.o : arp.c parprouted.h

parprouted.sh: parprouted.sh.in Makefile
	sed s#@PREFIX@#$(PREFIX)#g parprouted.sh.in > parprouted.sh
