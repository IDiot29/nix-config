{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = ["/run/secrets/rendered/ssh-config"];
  };
}
