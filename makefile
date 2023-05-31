CFLAGS=-Wall -Werror -Ijson/include -std=c++20

packsnap: main.cpp *.hpp **/*.hpp
	$(CXX) -o packsnap $(CFLAGS) main.cpp