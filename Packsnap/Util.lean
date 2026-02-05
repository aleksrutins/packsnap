namespace Packsnap.Util

def getMajorVersion (version : String) (default : String) : String :=
  (((version.splitOn ".").head?.getD default).dropWhile (λ c => ¬Char.isDigit c)).toString
