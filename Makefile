ifeq ($(RTE_SDK),)
$(error "Please define RTE_SDK environment variable.")
endif
RTE_TARGET ?= x86_64-native-linuxapp-gcc
PSPGEN_PMD ?= ixgbe
PSPGEN_RTE_LIBS = rte_eal rte_cmdline rte_timer rte_mempool rte_mbuf rte_ring ethdev rte_pmd_$(PSPGEN_PMD)
ifeq ($(PSPGEN_PMD),mlx4)
PSPGEN_RTE_LIBS += ibverbs
endif
ifeq ($(PSPGEN_PMD),mlnx_uio)
PSPGEN_RTE_LIBS += rte_persistent rte_hash
endif

CFLAGS = -std=gnu99 -march=native -Wall -O2 -g -I$(RTE_SDK)/$(RTE_TARGET)/include
LDFLAGS = -L$(RTE_SDK)/$(RTE_TARGET)/lib -pthread -lrt -lnuma -lzmq -Wl,--whole-archive -Wl,--start-group $(patsubst %,-l%,$(PSPGEN_RTE_LIBS)) -Wl,--end-group -Wl,--no-whole-archive -ldl

.PHONY: clean

pspgen: pspgen.c
	gcc $(CFLAGS) pspgen.c -o pspgen $(LDFLAGS)

clean:
	rm pspgen
