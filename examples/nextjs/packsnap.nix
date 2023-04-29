
{ packsnap ? import ../../. {} }:
packsnap.lib.build { name = "packsnap-nextjs"; path = ./.; }
    
