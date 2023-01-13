# xui-trojan
Automated deployment of Trojan VPN protocol on X-UI using Docker

## Guide
### Setting up UFW (Uncomplicated Firewall)
1. If your firewall is already active (check via `sudo ufw status`) skip to step 2, otherwise run the following commands to bring up UFW with default policies:
    1. `sudo ufw enable`
    2. `sudo ufw default deny incoming`
    3. `sudo ufw default allow outgoing`
    5. `sudo ufw allow ssh` - Allow SSH connections!
2. Allow `http` and `https` connections through your firewall:
    1. `sudo ufw allow http`
    1. `sudo ufw allow https`

### Installing Docker
1. Install Docker engine: `curl -fsSL https://get.docker.com | sh`
2. Add Docker to *sudo* group:
    1. `sudo groupadd docker`
    2. `sudo usermod -aG docker $USER`
3. Logout and Login to apply chanages.
