BUILDDIR = $(CURDIR)/build

all: $(BUILDDIR)/carg-os.elf

clean:
	@$(RM) -rf $(BUILDDIR)

karg:
	@git clone https://github.com/carg-os/karg.git

init:
	@git clone https://github.com/carg-os/init.git

libc:
	@git clone https://github.com/carg-os/libc.git

CC = $(CROSS_PREFIX)gcc

LDFLAGS = -nostdlib -Wl,--gc-sections -flto

LIBS = $(BUILDDIR)/karg.a \
       $(BUILDDIR)/init.a \
       $(BUILDDIR)/libc.a

FORCE:

$(BUILDDIR)/karg.a: FORCE | karg
	@$(MAKE) -C karg BUILDDIR=$(BUILDDIR)

$(BUILDDIR)/init.a: FORCE | init libc
	@$(MAKE) -C init BUILDDIR=$(BUILDDIR) LIBC_INCLUDE=$(CURDIR)/libc/include

$(BUILDDIR)/libc.a: FORCE | libc
	@$(MAKE) -C libc BUILDDIR=$(BUILDDIR)

$(BUILDDIR)/carg-os.elf: $(LIBS) karg/kernel.ld | karg
	@printf "  CCLD\t$(@F)\n"
	@$(CC) $(LIBS) -o $@ -T karg/kernel.ld $(LDFLAGS)

run: $(BUILDDIR)/carg-os.elf
	@qemu-system-riscv64 -M virt -nographic -kernel $<
