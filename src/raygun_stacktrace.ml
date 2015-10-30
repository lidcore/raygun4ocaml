open Printexc

let of_backtrace bt =
  let f res slot =
    match Slot.location slot with
      | None -> res
      | Some {filename; line_number} ->
          res @ [{Raygun_t.
                   fileName   = Some filename;
                   lineNumber = Some line_number;
                   className  = None;
                   methodName = None}]
  in
  match backtrace_slots bt with
    | None       -> []
    | Some slots ->
       Array.fold_left f [] slots
