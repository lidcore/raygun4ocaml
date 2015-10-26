type t = CalendarLib.Date.t
let now = CalendarLib.Date.today
let wrap = CalendarLib.Printer.Date.from_fstring "%F"
let unwrap = CalendarLib.Printer.Date.sprint "%F"
