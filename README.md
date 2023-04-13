# x-ui
I'll explain how to setup the popular *v2ray* platform to bypass any [GFW](https://en.wikipedia.org/wiki/Great_Firewall) like a knife through butter. If you like the project and found it helpful, please do star and share with others!

## Table of Contents
- 💫 [First things first](https://github.com/keivanipchihagh/x-ui#-first-things-first)
- 🪖 [(Optional) Hold on to your Firewalls!](https://github.com/keivanipchihagh/x-ui#-optional-hold-on-to-your-firewalls)
- 🐳 [Run it with Docker!](https://github.com/keivanipchihagh/x-ui#-run-it-with-docker)
- 🚀 [Let the dashboard, Begin!](https://github.com/keivanipchihagh/x-ui#-let-the-dashboard-begin)
- 🔐 [Secure with SSL](https://github.com/keivanipchihagh/x-ui#-secure-with-ssl)
- 📬 [Create Inbounds](https://github.com/keivanipchihagh/x-ui#-enrich-your-clients)
- 👻 [IPv6 is here!](https://github.com/keivanipchihagh/x-ui#-ipv6-is-here)
- ❄️ [Using Bridge Server](https://github.com/keivanipchihagh/x-ui#-using-bridge-server)
- 🚅 [Faster TCPs](https://github.com/keivanipchihagh/x-ui#-faster-tcps)
- 🧱 [Hide behind CDN](https://github.com/keivanipchihagh/x-ui#-hide-behind-cdn)
- 🎗️ [Benchmarks](https://github.com/keivanipchihagh/x-ui#-benchmarks)
- 🤝 [Issues and Contributions](https://github.com/keivanipchihagh/x-ui#-issues-and-contributions)
- 📖 [Credits](https://github.com/keivanipchihagh/x-ui#-credits)

## 💫 First things first
1. Get a Domain, buy a Server (with *minimum* hardware requirements) and create a [Cloudflare](https://cloudflare.com/) account.
2. Map a subdomain to your server IPv4 (Leave proxied *unchecked!*). This can take a few minutes to take effect.

> **Note**
> There is no need to set any NS records if you are only using the server as a VPN.

## 🪖 (Optional) Hold on to your Firewalls!
I always enjoy the extra security on my servers. If you suffer from *ADHD* like I do (*LOL!*), there is an script for you! Run `scripts/setup-ufw.sh` to configure a minimal Firewall with default policies (allows ports **22**, **80**, **443** and *54321* for X-UI).

> **Warning**
> With firewall enabled, you must allow each X-UI inbound port in it, or you won't be able to connect!

## 🐳 Run it with Docker! 
I'm going to use [Docker](https://www.docker.com/), because it's clean and leaves no trace afterwards. You can remove the container at any time. Install Docker by running the ``scripts/setup-docker.sh` script.

> **Note**
> The script will install *Docker Engine*, *docker-compose* and add them to sudo group.

## 🚀 Let the dashboard, Begin!
1. There is a file called `.env.template` which containes placeholders for variables that you must change to your liking. Afterwards, rename the file to `.env`.
2. Make sure nothing is blocking port **80** and **443** until the end of this section. If there is any process using it at the time, stop it temporarily.
3. Run the `build.sh` script which generates a SSL certificate using [CertBot](https://certbot.eff.org/) and deploys the **X-UI** container.
4. Access your dashboard via `<SERVER-IP>:<DASHBOARD-PORT>` where the default dashboard port is `54321`.

> **Warning**
> SSL certificate generation will fail if the **DOMAIN** in `.env` does not match the one setup in Cloudflare!

> **Warning**
> The default username and password for the dashboard are "**admin**". Change them immediately!

## 🔐 Secure with SSL
You can access your dashboard via `<SERVER-IP>:<DASHBOARD-PORT>` or connect to your inbounds without any TLS encryption, but that leaves you exposed and will get you blocked within days! To enable SSL on your dashboard:
1. On your [Cloudflare](https://cloudflare.com/) account, set the *SSL/TLS* level to `strict` or beyond.
2. Navigate to **Panel Settings** and change the following fields (replace `DOMAIN` with your own):
    - Panel *certificate.crt* file path: `/etc/letsencrypt/live/{DOMAIN}/fullchain.pem`
    - Panel *private.key* file path: `/etc/letsencrypt/live/{DOMAIN}/privkey.pem`

From now on, always access your dashboard via `<DOMAIN>:<DASHBOARD-PORT>` which is on a secure channel now! Good for you.

## 📬 Enrich your clients
Create inbounds for your clients. Note the followings:
- Stick with **XTLS** rather than **TLS** if at all possible.
- Always add *"Certificate.crt"* and *"Private.key"* paths for each inbound to enable TLS.
- Enable **Sniffing** if available.
- Check *Disable insecure connections* (except for very old devices!)

> **Note**
> **TCP** is generally faster (specially in an environment where GFW is dropping packets!), but **Websocket** can be configured behind CDN to hide your identity.

## 👻 IPv6 is here!
Does IPv6 enable you to connect on spesific ISPs? It very much does!
1. You need three pieces: `PUBLIC_IPV6_GATEWAY`, `PUBLIC_IPV6_ADDRESS` and `IPV6_NAMESERVERS`
2. Set your servers `PUBLIC_IPV6_ADDRESS` into Cloudflare and point it to your **DOMAIN**.
3. Modify `/etc/netplan/50-cloud-init.yaml` like the example below (I had some other stuff here as well which you can ignore):
```yaml
network:
    version: 2
    ethernets:
        eth0:
            addresses:
            - PUBLIC_IPV4_ADDRESS/20
            - 10.48.0.9/16
            - PUBLIC_IPV6_ADDRESS/64
            match:
                macaddress: <HIDDEN>
            mtu: 1500
            nameservers:
                addresses:
                - <HIDDEN>
                - <HIDDEN>
                - IPV6_NAMESERVERS_1
                - IPV6_NAMESERVERS_2
                search: []
            routes:
            -   to: 0.0.0.0/0
                via: PUBLIC_IPV4_GATEWAY
            -   to: PUBLIC_IPV6_GATEWAY
                scope: link
            set-name: eth0
```

> **Note**
> Some parts have been hidden for my security, leave them to your defaults.

> **Warning**
> Don't choose IPv6 as your first/default/primary route, as many ISPs don't yet support it entirely!

## ❄️ Using Bridge Server
So [GFW](https://en.wikipedia.org/wiki/Great_Firewall) can't shut you down, but it can still make you suffer! How? By doing [Packet Drop](https://geneva.cs.umd.edu/posts/fully-encrypted-traffic/en/) on traffic heading to the outside world. To overcome this, **v2ray** supports using a bridge-server (aka.  [Tunneling](https://traefik.io/glossary/network-tunneling/)):
1. Buy a server within the country, repeat the entire process of brining up X-UI on your new server.
2. Create an inbound on your upstream-server (preferable, `Websocket` for stable connection) with TLS enabled.
3. Replace the configurations from `v2ray/bridge-server.json` with the existing `XRAY Configuration` on your X-UI dashboard settings (Change spesific parts accoring to your upstream inbound).

> **Note**
> Tunneling will bypass any censorship and restrictions, but at a price of speed.

> **Note**
> You need another subdomain to use for your bridge-server, but with no CDN! (This is quite important)


## 🚅 Faster TCPs
Using Google's upgraded congestion control algorithms will slightly improve your *TCP* connections speed. To apply it on your system, run the following commands:
```bash
$ bash scripts/bbr.sh
```

## 🧱 Hide behind CDN
This part is tricky! Make sure your VPN does indeed work **before** following the next procedure:
1. Create a new inbound with the following configurations:
    - Protocol: `vmess` or `vless`
    - Port: preferably `443` (default HTTPS port)
    - Transmission: `ws`
    - Turn on TLS, fill *domain* and certification files like before
2. Turn on proxied on Cloudflare (CDN)
3. Wait about a minute or two for it to process. You can check if changes are applyed pinging your subdomain and notice your real server IP is now hidden!

> **Warning**
> **TCP** and **UDP** protocols no longer work with CDN enabled, as CDN is a streaming service! Use only *Websocket*.

> **Note**
> Changes can take place from in few minutes and sometimes an hour. Grab some popcorn 🍿

## 🎗️ Benchmarks

## 🤝 Issues and Contributions
Feel free to ask questions via [issue](https://github.com/keivanipchihagh/xui-trojan/issues/new) and add features by opening a [pull request](https://github.com/keivanipchihagh/xui-trojan/pulls).

## 📖 Credits
- [BBR Script](https://github.com/teddysun/across)
- [X-UI Image](https://hub.docker.com/r/enwaiax/x-ui)
