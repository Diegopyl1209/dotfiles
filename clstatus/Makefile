CC = gcc
CFLAGS = -Wall -O2 $(shell pkg-config --cflags libpulse)
LDFLAGS = $(shell pkg-config --libs libpulse)

CFLAGS += $(shell pkg-config --cflags x11) -DX11
LDFLAGS += $(shell pkg-config --libs x11)

TARGET = clstatus
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

SRC = main.c \
	  components/volume.c \
	  components/datetime.c \
	  util.c \
	  backend.c

OBJ = $(SRC:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LDFLAGS)

main.o: config.h util.h backend.h components/components.h
components/volume.o: components/components.h util.h
components/datetime.o: components/components.h
util.o: util.h
backend.o: backend.h util.h

clean:
	rm -f $(TARGET) $(OBJ)

install: $(TARGET)
	install -Dm755 $(TARGET) $(BINDIR)/$(TARGET)

uninstall:
	rm -f $(BINDIR)/$(TARGET)
