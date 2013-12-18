
BIN = mush
PREFIX ?= /usr/local
MANPREFIX ?= $(PREFIX)/share/man/man1

all:
	@:

install:
	cp $(BIN).sh $(PREFIX)/bin/$(BIN)
	install $(BIN).1 $(MANPREFIX)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
	rm -f $(MANPREFIX)/$(BIN).1

test:
	./test.sh

doc:
	@curl -# -F page=@$(BIN).1.md -o $(BIN).1 http://mantastic.herokuapp.com
	@echo "$(BIN).1"

.PHONY: test
