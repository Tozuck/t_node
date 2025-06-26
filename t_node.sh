#!/bin/bash

echo_info() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}
echo_error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
  exit 1
}

apt-get update; apt-get install curl socat git nload speedtest-cli -y


if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sh || echo_error "Docker installation failed."
else
  echo_info "Docker is already installed."
fi

rm -r Marzban-node

git clone https://github.com/Gozargah/Marzban-node

rm -r /var/lib/marzban-node

mkdir /var/lib/marzban-node

rm ~/Marzban-node/docker-compose.yml

cat <<EOL > ~/Marzban-node/docker-compose.yml
services:
  marzban-node:
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host
    environment:
      SSL_CERT_FILE: "/var/lib/marzban-node/ssl_cert.pem"
      SSL_KEY_FILE: "/var/lib/marzban-node/ssl_key.pem"
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"
      SERVICE_PROTOCOL: "rest"
    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
EOL
curl -sSL https://raw.githubusercontent.com/Tozuck/Node_monitoring/main/node_monitor.sh | bash
rm /var/lib/marzban-node/ssl_client_cert.pem

cat <<EOL > /var/lib/marzban-node/ssl_client_cert.pem
-----BEGIN CERTIFICATE-----
MIIEnDCCAoQCAQAwDQYJKoZIhvcNAQENBQAwEzERMA8GA1UEAwwIR296YXJnYWgw
IBcNMjQwNzE5MTgyNTM0WhgPMjEyNDA2MjUxODI1MzRaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAv5iV9qjMIxRf
7EavlS7lEipgonTDvq8p65wVr+TtRrv18Tip1A2p9unEwEM5orRx8KbLOFiPE6NK
dDMOnq3MXdv2UY2RrVWB72BEKa6R9VPFx+I2CuhVfGY44gmNOd3rDaQe1VgQ4n56
29NuN/+ZvCQexd3ExfI+3v3lc3ht4QTkyzOaFSf/k/xeWaOChdV7NVNNak81i0DL
kZEakPBUbwseiLW/b2Mzx5qMtC7yAez6FjKZLWmNoJsyvyedPcOoEj7fj0Cloh1n
xJaMrY0i84GmheZSLMX6hHRKIRcddo3Q0llr9EiLkt2OTSXjRjMBWDy+w/cKTyFw
ycPX5Q0ADGZsTbwjVF+2yJxJZYnJW0TecGTK/wOS1Jl/jeSZ4SwrwI7FxpnHfTyJ
qTfXLPlK7Ei3ddMVFD19FrVzuVTpmfCOdwLA39BofKuwpUShpAF2B66DnD2iA9Bh
6hwOa7WoZM6nN7q1KkzpfaG7VQfIk3l5T+tPqp8dLn7WFL18F62wvBW4xgicOJMD
ABTC/IzRGliK5IICXbtQ9POQnmx3CBRaj+FmYfTnaTx/NaWsoR3gPgI0+3YmXTTA
jm72FGC/+J+LnPVvdv67DOQJF+iYF6QBq8sEjAmfvd1qwK0Uj6Q66e3yZW64e9W/
TxO3hyvdu6bTkQgPC/vTuEvmiczBY20CAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
HvqJSSrY7jnS/NHzrhxEdg4jyy4Ra5La50sdqruVeOheRv5z/EF+j53iZKdM9HYk
1RG6EiBNjCyGYlOeE+H7fF0QzirYkOoUNugz2Eb9IxSX5YOxDRvvoXuanr41691H
nSbzkxnUXgK5xQMuiCcQ35Cf4mdIc+OvlRInUOFwJEG8nIV/PmColh/8JoWELMi3
0Wrj+jM5dwUcOIhf0ljHzM8HigEH0hsKqeQK5bdoTpjGwkWvDpsmbF5FagubB7Ot
IT0RVmtlgLwmQlAYtxMzP++cpHY3Q9nK8ec7TfVF+Tl1HqLDyWBVt3k10YbToYye
qsPot2VgUt28VBGHf/RMm/eCtZJYLu6wW/xToZhI/4Z1qzoe4+5kqZ2cdrZ5pRUp
8h7WHfWufVN4mszbtfGEB8rkT+ovfZfa81rYbxEI3KoeukLvADBdj1zzA9trV6t3
gx3W34WDLK2bDQZ6FwHDZhtsc2y1BeGYUWVdqRa/lvO9SPS/3TgsJ8g6/hqYysgA
A2NrE6TbNW1mq1k3+TyBijZqo6mOo+3f9bRxUricpB/NBkZ+nt66XwbaKbWvpelO
L55871tBzok1iaL1xiU/UmaF6/EaRWQnuEFqlSH8gQ7+XWeTElAem8WZu4e2Xav1
11PagJ/yGRTq4Xz02CMC9rAO+VaKWW515r/ZI3gA2C8=
-----END CERTIFICATE-----
EOL

cd ~/Marzban-node
docker compose up -d

echo_info "Finalizing UFW setup..."

ufw disable
