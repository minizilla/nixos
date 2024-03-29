{ pkgs }:

pkgs.mkShell {
  name = "nixos-config";
  shellHook = ''
    git config pull.rebase true
    ${pkgs.neo-cowsay}/bin/cowsay -f sage "Minizilla's NixOS Configurations"
  '';
  buildInputs = with pkgs; [
    editorconfig-checker
  ];
}
