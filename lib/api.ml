open Raygun_t

let client = {
  name = "raygun4ocaml";
  version = "0.1.0";
  clientUrl = "https://github.com/lidcore/raygun4ocaml"
}

let environment =
  let platform = Sys.os_type in
  let processorCount = None in
  let osVersion = None in
  let windowBoundsWidth = None in
  let windowBoundsHeight = None in
  let browser_Width = None in
  let browser_Height = None in
  let screen_Width = None in
  let screen_Height = None in
  let resolutionScale = None in
  let color_Depth = None in
  let currentOrientation = None in
  let cpu = None in
  let packageVersion = None in
  let architecture = None in
  let deviceManufacturer = None in
  let model = None in
  let totalPhysicalMemory = None in
  let availablePhysicalMemory = None in
  let totalVirtualMemory = None in
  let availableVirtualMemory = None in
  let diskSpaceFree = None in
  let deviceName = None in
  let locale = None in
  let utcOffset = None in
  let browser = None in
  let browserName = None in
  let browser_Version = None in
  { platform; processorCount; osVersion;
     windowBoundsWidth; windowBoundsHeight;
     browser_Width; browser_Height; screen_Width; screen_Height;
     resolutionScale; color_Depth; currentOrientation; cpu; packageVersion;
     architecture; deviceManufacturer; model; totalPhysicalMemory;
     availablePhysicalMemory; totalVirtualMemory; availableVirtualMemory;
     diskSpaceFree; deviceName; locale; utcOffset; browser; browserName;
     browser_Version }

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
  val report_uncaught_exceptions : ?refine:(Raygun_t.entry -> Raygun_t.entry) -> api_key:string -> unit
end

module Make(Http:Http_t) =
struct
  type t = Http.t

  let post_entry ~api_key entry =
    let url = "https://api.raygun.io/entries" in
    let body = Raygun_j.string_of_entry entry in
    let headers = [
        ("X-ApiKey", api_key);
        ("Content-Type", "application/json");
        ("Content-Length", string_of_int (String.length body))
      ]
    in
    Http.post ~body ~headers url

  let error_handler ?(refine=fun x -> x) ~api_key exn bt =
    let stackTrace =
      Some (Stacktrace.of_backtrace bt)
    in
    let message =  
      Some (Printexc.to_string exn)
    in
    let error = {
      message; stackTrace;
      innerError = None;
      data       = None;
      className  = None
    } in
    let details = {
      client; error; environment;
      machineName = None;
      version = None;
      tags = Some ["uncaught error"];
      userCustomData = None;
      request = None;
      response = None;
      user = None
    } in
    let entry = refine {
      occurredOn = Time.now ();
      details = details 
    } in
    Http.async (post_entry ~api_key entry)

  let report_uncaught_exceptions ?refine ~api_key () =
    Printexc.record_backtrace true;
    Printexc.set_uncaught_exception_handler (error_handler ?refine ~api_key)
end
