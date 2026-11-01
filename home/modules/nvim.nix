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
      lualine-nvim               # статусная строка
      bufferline-nvim            # вкладки буферов
      telescope-nvim plenary-nvim  # поиск
      nvim-treesitter.withAllGrammars  # подсветка
      gitsigns-nvim              # git в колонке
      which-key-nvim             # подсказки хоткеев
      nvim-autopairs             # автоскобки
      nvim-lspconfig             # LSP
      blink-cmp                  # автодополнение
    ];

    extraPackages = with pkgs; [
      ripgrep fd
      nil
      ];

  };
}
