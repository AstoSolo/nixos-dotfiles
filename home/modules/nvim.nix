{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua              
      nvim-web-devicons          
      lualine-nvim
      bufferline-nvim
      telescope-nvim plenary-nvim
      nvim-treesitter.withAllGrammars
      gitsigns-nvim
      which-key-nvim
      nvim-autopairs
      nvim-lspconfig
      blink-cmp
    ];

    extraPackages = with pkgs; [
      ripgrep fd
      nil
      ];

  };
}
