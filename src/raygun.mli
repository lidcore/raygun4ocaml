val client : Raygun_t.client
val environment : unit -> Raygun_t.environment
val post_entry : api_key:string -> Raygun_t.entry -> (Cohttp.Response.t * Cohttp_lwt_body.t) Lwt.t
