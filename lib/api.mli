val client      : Raygun_t.client
val environment : Raygun_t.environment 

module type Http_t =
sig
  type t
  val post : headers:((string*string) list) -> body:string -> string -> t
  val async : t -> unit
end

module type Api_t = 
sig
  type t
  val post_entry : api_key:string -> Raygun_t.entry -> t
  val report_uncaught_exceptions : ?refine:(Raygun_t.entry -> Raygun_t.entry) -> api_key:string -> unit -> unit
end

module Make : functor (Http:Http_t) ->
  Api_t with type t = Http.t
