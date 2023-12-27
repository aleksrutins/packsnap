
{ packsnap ? import ../../. {} }:
packsnap.lib.build { name = "packsnap-deno"; path = ./.; }
    
