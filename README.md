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
2. Allow `http` and `https` connections through your firewall:
    1. `sudo ufw allow http`
    2. `sudo ufw allow https`
    3. `sudo ufw allow 54321/tcp` - Allow XUI webserver
    4. `sudo ufw allow 12345/tcp` - Allow XUI inbound connections

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
