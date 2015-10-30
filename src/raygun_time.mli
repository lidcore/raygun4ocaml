type t
val now : unit -> t
val of_unix : float -> t
val unwrap : t -> string
val wrap : string -> t
