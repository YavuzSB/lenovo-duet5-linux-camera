# ==============================================================================
# Lenovo IdeaPad Duet 5 12IRU8 - Linux Camera Drivers Top-Level Makefile
# ==============================================================================

SUBDIRS := int3472 ipu-bridge ov5675 gc5035

.PHONY: all clean install uninstall test

all:
	@for dir in $(SUBDIRS); do \
		echo "===> Compiling module in $$dir..."; \
		$(MAKE) -C $$dir || exit 1; \
		for ko in $$dir/*.ko; do \
			if [ -f "$$ko" ]; then \
				echo "Compressing $$ko with in-kernel CRC32 support..."; \
				xz -f -9 --check=crc32 "$$ko"; \
			fi; \
		done; \
	done
	@echo "[+] All kernel modules compiled and compressed successfully."

clean:
	@for dir in $(SUBDIRS); do \
		echo "===> Cleaning $$dir..."; \
		$(MAKE) -C $$dir clean; \
		rm -f $$dir/*.ko.xz; \
	done
	@echo "[+] Clean complete."

install:
	@sudo bash yukle.sh

uninstall:
	@sudo bash kaldir.sh

test:
	@bash test.sh
