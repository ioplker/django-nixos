{ pkgs, ...}:
let
  python = pkgs.python39;
in
python.withPackages (ps: with ps; [
  django_3
  whitenoise    # for serving static files
  brotli        # brotli compression for whitenoise
  gunicorn      # for serving via http
  psycopg2      # for connecting to postgresql
])
