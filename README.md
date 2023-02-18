# xui-trojan
I'll explain how to setup the popular "*Trojan+XTLS+DNS+TCP*" stack that has worked seamlessly for months.
> **Note**
> You can also use other protocols like **VLESS** and **VMESS**. To my experience, **VLESS** is faster while **Trojan** is the more secure.

## 💫 First things first
1. Make sure you have a solid domain (use "**.ir**" if you want things to get more interesting😉).
2. Buy a server that is located outside our beloved country (I suggest [Digital Ocean](https://digitalocean.com/) for its many choices of locations).
3. Create a [Cloudfare](https://cloudflare.com/) account and set Clourflare's NS records on your domain (Changes may take 1-24 hours for your NS records to apply! track domain availability with [dnshealth](https://dnschecker.org/)).
4. Create a DNS record that maps a subdomain of your choice to your server IPv4 and **uncheck** proxied (meaning no CDN!). Changes can take up to an hour to settle in.

## 🪖 A little security won't hurt
I appriciate the extra security measures on my server, so I'll setup a minimal firewall. If yours is not enabled (check via `sudo ufw status`), run the following command to set it up: `sudo bash setup-ufw.sh`

This would setup UFW with default policies and allow **http**, **https** and **ssh** through.
> **Warning**
> The above script will reset your existing UFW policies! Don't run it if you already have configured the firewall.

## 🐳 Run it in Docker!
You should always use Docker for setting up your VPNs, because they can and will change network settings that can be hard to roleback. Install Docker by running the following script: `sudo bash setup-docker.sh`

That would isntall **Docker**, **docker-compose** and add *sudo* privileges to both for ease of use.

## 🚀 Create a SSL Certificate and X-UI dashboard
1. Create a `.env` file and set environmental variables accordingly (change them to your domain and email):
```python
DOMAIN=freedom.example.com
EMAIL=freedom@gmail.com
```
2. Temporarily, stop anything running on **port 80** since we need that to be free for this step.
3. Run the build script using `sudo bash build.sh` to generate a SSL certificate with **certbot** and build X-UI container.
> **Note**
> The X-UI dashboard is reachable by port *54321*. Use *freedom.example.com:54321* from our example to access it.

> **Warning**
> The default username and password are "**admin**". Change them or your clients can also access your dashboard (if they are smart enough😎).

## 🔐 Securing your dashboard with HTTPS
You can always access your dashboard via `<SERVER-IP>:<DASHBOARD-PORT>`, but that leaves you unprotected. Do the followings to establish a HTTPS connection with your dashboard:
1. On your [Cloudflare](https://cloudflare.com/) account, set the *SSL/TLS* level to `strict` and beyond.
2. Navigate to **Panel Settings** and change these fields as followed:
    - Panel certificate.crt file path: `/root/certs/fullchain.pem`
    - Panel private.key file path: `/root/certs/privkey.pem`

Now you can access your dashboard via `<DOMAIN>:<DASHBOARD-PORT>` which falls behind HTTPS.

## 📬 Creating Inbounds
1. Login to your X-UI dashboard and navigate to *inbounds* section.
2. Create a connection with the following configs:
    - Protocol: `Trojan`, `VMESS` or `VLESS`
    - Transmission: `TCP`
    - [x] XTLS: `checked!`
    - Domain name: `freedom.example.com (Change to yours!)`
    - Certificate.crt file path: `/root/certs/fullchain.pem`
    - Private.key file path: `/root/certs/privkey.pem`
    - [x] Sniffing: `checked!`
3. A random port will be assigned each time you create an inbound, but it's not accessible since we haven't allowed it in the firewall. For any client you create, allow it through your firewall using `sudo ufw allow {PORT}/tcp` (or use *udp* depending on your configurations).

> **Note**
> Login by the domain you created in step one (e.g. *freedom.example.com:54321*) and avoid using dashboard by IP. It matters and don't ask why...

## ☃️ Build up from here
Congratulations! But we are not done yet..
- X-UI can be buggy at times! double check every config you set.
- Which protocol to use is up to you! Try several and find which works best in your area.
- Not working on some ISPs? Could use **IPv6** if you know how😎. Nobody will look for you there...
- Want to hide your IP? Use **Nginx+CDN** and relay traffic to **port 443** to make it more challenging to detect you!

## 🤝 Issues and Contributions
Feel free to ask questions via [issue](https://github.com/keivanipchihagh/xui-trojan/issues/new) and add features by opening a [pull request](https://github.com/keivanipchihagh/xui-trojan/pulls).
