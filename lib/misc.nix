{}:
{
  pipe = exprs:
    with builtins;
    foldl' (val: fn: fn val) (head exprs) (tail exprs);
}