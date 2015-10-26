let client = {
  Raygun_t.
    name = "raygun4ocaml";
    version = "0.1.0";
    clientUrl = "https://github.com/lidcore/raygun4ocaml"
}

let environment  () =
  let platform = Sys.os_type in
  let processorCount =
    let f () =
      try
        let p =
          Unix.open_process_in "sysctl -n hw.ncpu"
        in
        Some (int_of_string (input_line p))
      with
        | _ -> None
    in
    match platform with
      | "Unix" -> f () 
      | _ -> None
  in
  let extunix_try f =
    try
      Some (f ())
    with ExtUnixAll.Not_available _ -> None
  in
  let osVersion =
    extunix_try (fun () ->
      let uname = ExtUnixAll.uname () in
      uname.ExtUnixAll.Uname.release)
  in
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
  { Raygun_t.platform; processorCount; osVersion;
     windowBoundsWidth; windowBoundsHeight;
     browser_Width; browser_Height; screen_Width; screen_Height;
     resolutionScale; color_Depth; currentOrientation; cpu; packageVersion;
     architecture; deviceManufacturer; model; totalPhysicalMemory;
     availablePhysicalMemory; totalVirtualMemory; availableVirtualMemory;
     diskSpaceFree; deviceName; locale; utcOffset; browser; browserName;
     browser_Version }

let post_entry ~api_key entry =
  let url = "https://api.raygun.io/entries" in
  let json = Raygun_j.string_of_entry entry in
  let headers =
    Cohttp.Header.add_list (Cohttp.Header.init ()) [
      ("X-ApiKey", api_key);
      ("Content-Type", "application/json");
      ("Content-Length", string_of_int (String.length json))
    ]
  in
  let uri = Uri.of_string url in
  let body =
    Cohttp_lwt_body.of_stream
      (Lwt_stream.of_list [json])
  in
  Cohttp_lwt_unix.Client.post ~body ~headers uri
