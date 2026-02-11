{
  inputs,
  ...
}: {
  imports = [
    inputs.self.darwinModules.aerospace
    inputs.self.darwinModules.common
    inputs.self.darwinModules.homebrew
    inputs.self.darwinModules.secrets
  ];
}
