project('packsnap', 'c', 'vala',
  version : '0.1',
  default_options : ['warning_level=3'])

executable('packsnap',
           'main.vala',
           dependencies : [
            dependency('glib-2.0'),
            dependency('gio-2.0'),
            dependency('gobject-2.0')
           ],
           install : true)
