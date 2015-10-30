open Lwt

module Http =
struct
  type t = (Cohttp.Response.t * Cohttp_lwt_body.t) Lwt.t

  let post ~headers ~body uri =
    let headers =
      Cohttp.Header.add_list (Cohttp.Header.init ()) headers
    in
    let uri = Uri.of_string uri in
    let body =
      Cohttp_lwt_body.of_stream
        (Lwt_stream.of_list [body])
    in
    Cohttp_lwt_unix.Client.post ~body ~headers uri

  let async th =
    Lwt.async (fun () ->
      th >>= fun (_) -> return_unit)
end

module Api = Raygun.Api(Http)
