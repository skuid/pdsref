.PHONY: clean

clean:
	@./clean.sh

install:
	@./setup.sh

start:
	@./start.sh

upgrade:
	@./upgrade.sh

dbinstall:
	@./localdb_install.sh

dbstart:
	@./localdb_start.sh
