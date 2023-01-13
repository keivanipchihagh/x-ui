# xui-trojan
Automated deployment of Trojan VPN protocol on X-UI using Docker

## Guide

### Before we begin
1. Make sure you have a solid domain, a server anywhere **outside our beloved country** and a [Cloudfare](https://cloudflare.com/) account with configured DNS records on your domain and server IP
2. Create a DNS record with a subdomain of your choice and leave everything else an default except for the CDN! Make sure the *proxied* is unchecked! (changes can take up to 24h to settle in, check availability with [intodns](https://intodns.com/))

### Setting up UFW (Uncomplicated Firewall)
1. If your firewall is already active (check via `sudo ufw status`) skip to step 2, otherwise run the following commands to bring up UFW with default policies:
    1. `sudo ufw enable`
    2. `sudo ufw default deny incoming`
    3. `sudo ufw default allow outgoing`
    5. `sudo ufw allow ssh` - Allow SSH connections!
    6. `sudo ufw allow http`
    2. `sudo ufw allow https`

### Installing Docker
1. Install Docker engine: `curl -fsSL https://get.docker.com | sh`
2. Add Docker to *sudo* group:
    1. `sudo groupadd docker`
    2. `sudo usermod -aG docker $USER`
3. Logout and Login to apply chanages.

### Setting up SSL ertificate & X-UI dashboard
1. Create a `.env` file with the following contents (Change them accordingly!):
    ```bash
    DOMAIN=vsubdomain.domain.something
    EMAIL=example@test.com
    ```
2. Make sure port **80** is free; If not, disabled anything using temporarily and enabled it after step 3.
3. Run the following script `bash build.sh` that does the followings:
    1. Generate an SSL certificate using [certbot](https://certbot.eff.org/) which is stored at `./certs/{DOMAIN}/`
    2. Boot the X-UI panel on port 54321 with the default username and password set to **admin**. We will change it later..
4. To access X-UI webserver from your browser run `sudo ufw allow 54321/tcp`.

### Creating Inbounds
1. Login to your X-UI dashboard and navigate to *inbounds* section.
2. Create a connection with the following configs (replace *{DOMAIN}* with your own):
    - Protocol: **Trojan**
    - Transmission: **TCP**
    - [x] XTLS: checked!
    - Domain name: {DOMAIN}
    - Certificate.crt file path: **/root/certs/{DOMAIN}/fullchain.pem**
    - Private.key file path:
    - Certificate.crt file path: **/root/certs/{DOMAIN}/privkey.pem**
    - [x] Sniffing: checked!
3. A random port will be assigned to any incoming record you create, but it's not accessible because we have a firewall. You have two choices:
    - (difficault, but secure) For any incoming record you make, allow the port through firewall with `sudo ufw allow {PORT}/tcp`.
    - (easy-peasy, but not secure) Disable firewall with `sudo ufw disable` and add any number of ports you want.
