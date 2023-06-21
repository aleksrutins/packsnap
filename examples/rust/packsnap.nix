{ packsnap ? import ../../. {} }:
packsnap.lib.build { name = "packsnap-rust"; path = ./.; }
