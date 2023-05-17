project('packsnap', 'cpp',
  version : '0.1',
  default_options : ['warning_level=3',
                     'cpp_std=c++20'])

packsnap_srcs = ['packsnap.cpp']
packsnap_deps = [
  dependency('nlohmann_json', fallback: ['nlohmann_json', 'nlohmann_json_dep'])
]

subdir('oci')
subdir('util')

exe = executable('packsnap', packsnap_srcs,
  dependencies : packsnap_deps,
  include_directories : include_directories('include'),
  install : true)

test('basic', exe)
