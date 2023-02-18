# xui-trojan
I'll explain how to setup the popular "*Trojan+XTLS+DNS+TCP*" stack that has worked seamlessly for months.
> **Note**
> You can also use other protocols like **VLESS** and **VMESS**. To my experience, **VLESS** is faster while **Trojan** is the more secure.

## 💫 First things first
1. Get a Domain, buy a Server and create a [Cloudflare](https://cloudflare.com/) account.
2. Set NS records that points your domain to your server. (Changes can take 1-24 hours to apply!) Meanwhile, track domain availability with [dnshealth](https://dnschecker.org/)).
3. Map a subdomain to server IP (Leave *proxied* unchecked!)

## 🪖 (Optional) Hold on to your Firewalls!
I always enjoy the extra security on my servers. If you suffer from ADHD like I do (*LOL!*), there is an script for you! Run `setup-ufw.sh` to configure a minimal Firewall with default policies.

> **Warning**
> If you enable Firewall, you have to allow each X-UI inbound through it!

## 🐳 Run it with Docker! 
I'm going to use [Docker](https://www.docker.com/), because it's clean and leaves no trace. You can remove the container like nothing ever happened. Install it by running the `setup-docker.sh` script.

> **Note**
> The script will install *Docker Engine*, *docker-compose* and add them to sudo group.

## 🚀 Let the dashboard, Begin!
1. There is a file called `.env.template` which containes two placeholders that you must adjust to yours, and then rename the file to `.env`.
2. Make sure nothing is blocking port 80 until the end of this section. If there is, stop it temporarily.
3. Run the `build.sh` script which generates a SSL certificate using **certbot** and deploy the X-UI container.
4. Access your dashboard via `<SERVER-IP>:<DASHBOARD-PORT>` where the default dashboard port is `54321`.

> **Warning**
> The default username and password for the dashboard are "**admin**". Change them immediately!

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
