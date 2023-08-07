{ pkgs ? import <nixpkgs> {} }:
let
  myEmacs = pkgs.emacs-gtk;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;

in
emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
  magit
  zerodark-theme
]) ++ (with epkgs.melpaPackages; [
  nix-mode
  gruber-darker-theme
  cdlatex
]) ++ (with epkgs.elpaPackages; [
  auctex
  beacon
]))
