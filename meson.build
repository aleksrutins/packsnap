project('packsnap', 'c',
  version : '0.1',
  default_options : ['warning_level=3'])

packsnap_srcs = ['packsnap.c']

subdir('oci')
subdir('util')

exe = executable('packsnap', packsnap_srcs,
  include_directories : include_directories('include'),
  install : true)

test('basic', exe)
