
{ packsnap ? import ../../. {} }:
packsnap.lib.build { name = "packsnap-node"; path = ./.; }
    
