class logger tag = 
object (self)
  val mutable tag = tag
  method print style message_type message = Printf.printf "\x1B[%sm%s(%s):\x1b[0m %s\n" style message_type tag message
  method info = self#print "2" "info"
  method debug = self#print "35" "debug"
  method err = self#print "1;31" "error"
  method warn = self#print "33" "warn"
end