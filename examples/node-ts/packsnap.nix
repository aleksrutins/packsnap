
{ packsnap ? import ../../. {} }:
packsnap.lib.build { name = "packsnap-node-ts"; path = ./.; }
    
