{ config, pkgs, ... }:
with pkgs;
let django = (import (builtins.fetchGit {
    url = "https://github.com/ioplker/django-nixos";
    ref = "master";
    rev = "2658eef91c090b281f3f3b7cd24233d858ee9e5c";
  })) {

  inherit pkgs;
  name = "djangoproject";
  keys-file = toString ../django-keys;
  settings = "djangoproject.settings_nix";
  src = "${../djangoproject}";
  python = pkgs.python39.withPackages ( ps: with ps; [
    django_3_2
    whitenoise
    brotli
    gunicorn
    psycopg2
    requests  # as an example we add requests
  ]);
};
in
{
  imports = [ django.system-config ];
}
