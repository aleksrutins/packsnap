CFLAGS=-Wall -Werror

packsnap: main.cpp *.hpp **/*.hpp
	$(CXX) -o packsnap $(CFLAGS) main.cpp