(lang dune 3.7)

(name packsnap)

(generate_opam_files true)

(source
 (github aleksrutins/packsnap))

(authors "Aleks Rutins")

(maintainers "Aleks Rutins")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name packsnap)
 (synopsis "A fast container build system")
 (description "A longer description")
 (depends ocaml dune)
 (tags
  (docker oci)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
