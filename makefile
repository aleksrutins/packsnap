CFLAGS=-Wall -Werror -Ijson/include

packsnap: main.cpp *.hpp **/*.hpp
	$(CXX) -o packsnap $(CFLAGS) main.cpp