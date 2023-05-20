let print style message_type message tag =
  Printf.printf "\x1B[%sm%s(%s):\x1b[0m %s\n" style message_type tag message

let info = print "2" "info"
let debug = print "35" "debug"
let err = print "1;31" "error"
let warn = print "33" "warn"
