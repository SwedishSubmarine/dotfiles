{...}:
{
  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        avg_cpu = true;
        group_processes = true;
        temperature_type = "c";
      };
    };
  };

  catppuccin.bottom.enable = true;
}
