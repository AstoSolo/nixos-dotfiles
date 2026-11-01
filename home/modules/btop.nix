{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    package = pkgs.btop.override { rocmSupport = true; };
    settings = {
      color_theme = "tty";
      theme_background = false;
      shown_boxes = "cpu mem net proc";
      show_gpu_info = "Auto";
      shown_gpus = "nvidia amd intel apple";
      gpu_mirror_graph = true;
      graph_symbol_gpu = "default";
    };
  };
}
