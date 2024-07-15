#!/bin/bash
# GT_marz: A script to set up Marzban node

# Update and install necessary packages
apt-get update
apt-get install curl socat git -y

# Pause for 2 seconds
sleep 2

# Disable UFW
ufw disable

# Install Docker
curl -fsSL https://get.docker.com | sh

# Pause for 2 seconds
sleep 2

# Clone the Marzban-node repository
git clone https://github.com/Gozargah/Marzban-node

# Create directory for Marzban-node
mkdir /var/lib/marzban-node

# Pause for 2 seconds
sleep 2

# Edit the docker-compose.yml file
cat <<EOL > ~/Marzban-node/docker-compose.yml
services:
  marzban-node:
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host

    environment:
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"

    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
EOL

# Create SSL certificate file
cat <<EOL > /var/lib/marzban-node/ssl_client_cert.pem
-----BEGIN CERTIFICATE-----
MIIEnDCCAoQCAQAwDQYJKoZIhvcNAQENBQAwEzERMA8GA1UEAwwIR296YXJnYWgw
IBcNMjQwNjIzMTQyMDQ4WhgPMjEyNDA1MzAxNDIwNDhaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvih1mAlsSQgI
2J6ZJOPG/uOpyBJhk+nYmHmUSxu81kFDsCtTbGj+ykd/00j7hKfG5KUOyZkp4bSg
ivZWlRIKsCEwvpuHpo1uxwHRX18JImozffBB8gKwfJHbItEw+0xjFSFIY3heLzfk
tzS3VUxw/Yi9ZcE/o7wGH/P4PZyyHQgcs4/l2bNQ87gHRvOXo0IlXjbRUmbOXiT7
KK3jYOWJmzT4ULM0g6NNi5qwlSHEZ9wMbuKnxao1e+9JD9tqR0i9UlLS0qyzDu+z
ck/tse5CY7qjHFEmfYUAV8F0yTU4EaOkwsUwpK0Uti0zvxL8An9zJTEjUdnYMis2
bBBN6hOyUeUNoel4kg2HtTb6uYXkOwsDjeDTnke++z5q9PfGJtNmc3LMksbFc069
mx78a8BP/u9aEe1GLQoQz0nmkOpxXXVFz+2Osn6XQbepyY12Uin2jzapERqOSFxP
YQuHznh6fVhnWmD5IteE6GefUYN7GVYTDj19G4tC5BBDKxGcqu6w2GRg/8zZ791f
Ux2UYNNrb5wV1PQ7eo7cYn/vccfCk0Feaq3B0ISiXnYdbbD1SWVr9Smh3wK8RMPK
0gf/w/D0i+BcojTr6PKi6dl+dpgE3DrMRdsp+Q2bQnOHKn73oOaS2vL7Ovnqqnyj
AvA4fMI37/D6YC3rBYuCBEO8CIqeWYMCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
VAx+0yr/sDdu/sfaKghxoggmkp6NpoCb8uzrSrHpOTL0xAmyUYzggYjYqmMGQoc+
kklRsgorKPHqTzZv1a3/GFgtL3z/15qo624r46hTk2iM6fE0+VVksUDD3pisLT6K
FbXx5LzsDupgHSp9kJtPjigj4TBJwgmXTDKTkpY998dqvVVrlJMDuJ9mru8iTuBR
8dLvhPl/LRZw71vPSNDbgCLT/+3vx+PhYl6kPbYST+OUnQtpzSrefD8tV3wYScze
TNmLrtK8mxWO7smXmVcfOacFvO6lDj0eBxvjKovug9ZFShLL5bztX4DYVZeDYCVZ
qtnVfE4akaB4BoUZsDB0V2cA8nnif8Dk4FktWEFhj+ZIt/+b8MNLZPqwrbzpqMNH
eIzwrBA8KtVzPuj4upNQaW9TGy92FeBf1yR+nPGrEhnZMbv4n4AWRwdLtkHmi86u
LbAguAXkHGsSgwaar2ipmGqjlMDwhCpIrcR2GvVi4lY54ARnHiOQ2RBODo0mDLDz
hAVJJCgvHOlxuGgz2lDd+vOW0GYdE7Wj30aIT7GDLO28aObKgGYrXQOSOzrqt+GY
065dnL788942Y965n+tV51wdfR2UOBGvVaBva4fnfUZS/SKDMK9yR03omTDN51kB
ZKuDULjL23UUbAP5l+/obg1NbzhTg2y0dbkU08yl4Dc=
-----END CERTIFICATE-----
EOL

# Pause for 3 seconds
sleep 3

# Run Docker Compose to start Marzban node
cd ~/Marzban-node
docker compose up -d


