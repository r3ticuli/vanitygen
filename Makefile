LIBS= -lpcre -lcrypto -lm -lpthread
INCPATHS=-I$(shell brew --prefix)/include -I$(shell brew --prefix openssl)/include
LIBPATHS=-L$(shell brew --prefix)/lib -L$(shell brew --prefix openssl)/lib
CFLAGS=-ggdb -O3 -Wall -Qunused-arguments $(INCPATHS) $(LIBPATHS)

PLATFORM=$(shell uname -s)
ifeq ($(PLATFORM),Darwin)
OPENCL_LIBS=-framework OpenCL
else
OPENCL_LIBS=-lOpenCL
endif


most: vanitygen keyconv

all: $(PROGS)

vanitygen: vanitygen.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

oclvanitygen: oclvanitygen.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS)

oclvanityminer: oclvanityminer.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS) -lcurl

keyconv: keyconv.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

clean:
	rm -f $(OBJS) $(PROGS) $(TESTS)
