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
  port = 8000;
};
in
{
  imports = [ django.system-config ];
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # nginx proxy
  services.nginx = {
    enable = true;
    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    # reverse proxy with automatic letsencrypt
    virtualHosts."example.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:" + toString(8000) + "/";
      # taking advantage of whitenoise's compression
      locations."/".extraConfig = ''proxy_set_header Accept-Encoding "br, gzip";'';
    };
  };
  services.ddclient = {
    enable = true;
    protocol = "duckdns";
    password = "your_duckdns_token";
    domains = ["example.duckdns.org"];
  };
}
