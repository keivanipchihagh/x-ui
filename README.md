# xui-trojan
I'll explain how to setup the popular Trojan+XTLS+DNS+TCP configuration that has worked fine up to now, but the same procedure applies for any other combinations.

## Steps

### Before we begin
1. Make sure you have a solid domain, a server anywhere **outside our beloved country** and a [Cloudfare](https://cloudflare.com/) account with configured DNS records on your domain and server IP.
2. Create a DNS record with a subdomain of your choice and leave everything else an default except for the CDN! Make sure the *proxied* is unchecked! (changes can take up to 24h to settle in, check availability with [intodns](https://intodns.com/)).

### Setting up UFW (Uncomplicated Firewall)
I enjoy the extra security measures on my server, so I'll have the firewall enabled. If yours is not (check via `sudo ufw status`), run the following commands to bring it up with default policies:
1. `sudo ufw enable`
2. `sudo ufw default deny incoming`
3. `sudo ufw default allow outgoing`
5. `sudo ufw allow ssh` - Don't forget to allow SSH connections!
6. `sudo ufw allow http`
7. `sudo ufw allow https`

### Installing Docker
1. Install Docker engine: `curl -fsSL https://get.docker.com | sh`
2. Add Docker to *sudo* group:
    1. `sudo groupadd docker`
    2. `sudo usermod -aG docker $USER`
3. Logout and Login to apply chanages.

### Setting up SSL certificate & X-UI
1. Create a `.env` file with the following contents (Change them accordingly!):
    ```python
        DOMAIN=vsubdomain.domain.something
        EMAIL=example@test.com
    ```
2. For the [certbot](https://certbot.eff.org/) to work on its container, port **80** must be free. If it's not, disabled anything using it temporarily and enabled it after step 3.
3. Run the following command `bash build.sh` that does the followings:
    1. Generate a SSL certificate using [certbot](https://certbot.eff.org/) which is stored at `./certs/{DOMAIN}/`
    2. Boot the X-UI panel on port 54321 with the default username and password set to **admin**. Change it later..
4. Make sure you certificates are created in `./certs/{DOMAIN}/` and don't go any further if they didn't. Read logs from `./letsencrypt/var/logs/` to find the problem.
5. To allow X-UI thorugh your firewall run `sudo ufw allow 54321/tcp`.

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
3. A random port will be assigned each time you create record, but it's not accessible due firewall blockage. For any client you create, allow it through your firewall using `sudo ufw allow {PORT}/tcp`.

## Notes worth mentioning
- Changes made to your DNS records can sometimes take time take place (up to 24h). Have patience.
- You can disable firewall and save yourself the pain of allowing each port throught it.
- X-UI can be buggy at times! after you copy the client profile, double check the domain to be correct.
- If Trojan protocol timed out, there might be a problem with you SSL certificate. Try a `VMESS` to confirm the issue.
- Trojan+XTLS+DNS+TCP has proven bypass any filtering technologies, but do try different protocols and see what gives you the best experience.

## 🤝 Issues and Contributions
Feel free to ask your questions by opening an [issue](https://github.com/keivanipchihagh/xui-trojan/issues/new).
