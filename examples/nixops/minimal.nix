{ config, pkgs, ... }:
with pkgs;
let
  destKeysDir = "/keys";  # define target key dir for nixops

  django = (import (builtins.fetchGit {
    url = "https://github.com/ioplker/django-nixos";
    ref = "master";
    rev = "2658eef91c090b281f3f3b7cd24233d858ee9e5c";
  })) {

    # Parameters of the particular django project
    inherit pkgs;
    name = "djangoproject";
    keys-file = toString "${destKeysDir}/django-keys";  # path created by NixOps
    settings = "djangoproject.settings_nix";
    src = "${../djangoproject}";
  };
in
{
  imports = [ django.system-config ];
  # We upload the keys-file via NixOps' keys feature
  deployment.keys = {
    django-keys = {
      keyFile = ../django-keys;
      destDir = destKeysDir;
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 ];
}
