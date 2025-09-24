{ pkgs, inputs, ... }: 

{

  imports = [ inputs.dms.homeModules.dankMaterialShell ];

  programs.dankMaterialShell.enable = true;
  programs.dankMaterialShell = {
    enableSpawn = false;
    enableKeybinds = false;
    enableCalendarEvents = false;
    quickshell.package = inputs.quickshell.packages.${pkgs.system}.default;
  };

  services.cliphist.enable = true;
  services.cliphist.allowImages = true;
}

