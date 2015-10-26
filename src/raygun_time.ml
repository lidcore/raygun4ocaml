type t = float
let now = Unix.time
let wrap str = ISO8601.Permissive.datetime str
let unwrap = ISO8601.Permissive.string_of_datetime
