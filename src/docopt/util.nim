# Copyright (C) 2015 Oleh Prypin <blaxpirit@gmail.com>
# Licensed under terms of MIT license (see LICENSE)


import std/[strutils, unicode, macros]


template map_it*(lst, typ: typed, op: untyped): untyped =
  ## Returns `seq[typ]` that contains `op` applied to each `it` of `lst`
  var result {.gensym.}: seq[typ] = @[]
  for it {.inject.} in items(lst):
    result.add(op)
  result


proc is_upper*(s: string): bool =
  ## Is the string in uppercase (and there is at least one cased character)?
  let upper = unicode.to_upper(s)
  s == upper and upper != unicode.to_lower(s)


macro gen_class*(body: untyped): untyped =
  ## When applied to a type block, this will generate methods
  ## that return each type's name as a string.
  for typ in body[0].children:
    var meth = "method class(self: $1): string"
    if $typ[2][0][1][0] == "RootObj":
      meth &= "{.base, gcsafe.}"
    meth &= "= \"$1\""
    body.add(parse_stmt(meth.format(typ[0])))
  body
