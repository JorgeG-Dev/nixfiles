{
  self,
  inputs,
  config,
  pkgs,
  wlib,
  ...
}:
{
  flake.wrappers.neovim =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.neovim ];
      runtimePkgs = with pkgs; [
        # Other
        tree-sitter
        ripgrep

        # Adding the lua stuff here since it's helpful
        # for configuring lua
        stylua
        lua-language-server

        # Formatters
        nixfmt
      ];
      specs.general = with pkgs.vimPlugins; [
        lualine-nvim
        material-nvim
        nvim-web-devicons
        conform-nvim
        indent-blankline-nvim
        nvim-treesitter-context
        mini-pick
        blink-cmp
        arrow-nvim
        friendly-snippets # dep of blink-cmp
        (nvim-treesitter.withPlugins (p: [
          p.c
          p.python
          p.rust
          p.make
          p.gleam
          p.elixir
          p.zig
          p.nix
          p.lua
          p.bash
          p.dockerfile
          p.go
          p.cpp
          p.toml
        ]))
      ];
      settings = {
        config_directory = ./nvim;
      };
    };

  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.neovim.install ];
      wrappers.neovim.enable = true;
    };

  flake.modules.darwin.dev =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.neovim.install ];
      wrappers.neovim.enable = true;
    };
}
