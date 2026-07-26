{
  inputs,
  ...
}: {
  nix-homebrew.taps = {
    "BarutSRB/homebrew-tap" = inputs.omniwm-tap;
  };

  homebrew = {
    taps = [
      {
        name = "BarutSRB/tap";
        trusted = true;
      }
    ];
    casks = ["omniwm"];
  };

  launchd.user.agents.omniwm.serviceConfig = {
    ProgramArguments = [
      "/usr/bin/open"
      "-a"
      "OmniWM"
    ];
    ProcessType = "Interactive";
    RunAtLoad = true;
  };
}
