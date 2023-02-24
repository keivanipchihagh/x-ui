# x-ui
I'll explain how to setup the popular *v2ray* platform to bypass any [GFW](https://en.wikipedia.org/wiki/Great_Firewall) like a knife through butter. If you like the project and found it helpful, please do star and share with others!

## Table of Contents
- 💫 [First things first](https://github.com/keivanipchihagh/x-ui#-first-things-first)
- 🪖 [(Optional) Hold on to your Firewalls!](https://github.com/keivanipchihagh/x-ui#-optional-hold-on-to-your-firewalls)
- 🐳 [Run it with Docker!](https://github.com/keivanipchihagh/x-ui#-run-it-with-docker)
- 🚀 [Let the dashboard, Begin!](https://github.com/keivanipchihagh/x-ui#-let-the-dashboard-begin)
- 🔐 [Secure your dashboard with HTTPS](https://github.com/keivanipchihagh/x-ui#-secure-your-dashboard-with-https)
- 📬 [Create Inbounds](https://github.com/keivanipchihagh/x-ui#-enrich-your-clients)
- 👻 [IPv6 is here!](https://github.com/keivanipchihagh/x-ui#-ipv6-is-here)
- ❄️ [Annoying ISPs?](https://github.com/keivanipchihagh/x-ui#%EF%B8%8F-annoying-isps)
- 🧱 [Hide behind CDN](https://github.com/keivanipchihagh/x-ui#-hide-behind-cdn)
- 🎗️ [Benchmarks](https://github.com/keivanipchihagh/x-ui#-benchmarks)
- 🤝 [Issues and Contributions](https://github.com/keivanipchihagh/x-ui#-issues-and-contributions)

## 💫 First things first
1. Get a Domain, buy a Server (with *minimum* hardware requirements) and create a [Cloudflare](https://cloudflare.com/) account.
2. Map a subdomain record to your server IPv4 (Leave *proxied* unchecked!). This can take a few minutes to take effect.

> **Note**
> There is no need to set any NS records if you are only using the server as a VPN!

## 🪖 (Optional) Hold on to your Firewalls!
I always enjoy the extra security on my servers. If you suffer from *ADHD* like I do (*LOL!*), there is an script for you! Run `setup-ufw.sh` to configure a minimal Firewall with default policies (allows ports **22**, **80** and **443**).

> **Warning**
> With firewall enabled, you must allow each X-UI inbound port in it, or you won't be able to connect!

## 🐳 Run it with Docker! 
I'm going to use [Docker](https://www.docker.com/), because it's clean and leaves no trace afterwards. You can remove the container at any time. Install Docker by running the `setup-docker.sh` script.

> **Note**
> The script will install *Docker Engine*, *docker-compose* and add them to sudo group.

## 🚀 Let the dashboard, Begin!
1. There is a file called `.env.template` which containes placeholders for variables that you must change to your liking. Afterwards, rename the file to `.env`.
2. Make sure nothing is blocking port **80** and **443** until the end of this section. If there is any process using it at the time, stop it temporarily.
3. Run the `build.sh` script which generates a SSL certificate using **CertBot** and deploys the **X-UI** container.
4. Access your dashboard via `<SERVER-IP>:<DASHBOARD-PORT>` where the default dashboard port is `54321`.

> **Warning**
> The default username and password for the dashboard are "**admin**". Change them immediately!

## 🔐 Secure your dashboard with HTTPS
You can always access your dashboard via `<SERVER-IP>:<DASHBOARD-PORT>`, but that's not good for your health 😉. Do the followings to enable a HTTPS on your dashboard:
1. On your [Cloudflare](https://cloudflare.com/) account, set the *SSL/TLS* level to `strict` or beyond.
2. Navigate to **Panel Settings** and change these fields as followed:
    - Panel *certificate.crt* file path: `/root/certs/fullchain.pem`
    - Panel *private.key* file path: `/root/certs/privkey.pem`

Now you can access your dashboard via `<DOMAIN>:<DASHBOARD-PORT>` which falls behind HTTPS.

## 📬 Enrich your clients
Create inbounds for your clients. Note the followings:
- Stick with **XTLS** rather than **TLS** if at all possible.
- Always add *"Certificate.crt"* and *"Private.key"* paths to enable TLS.
- Enable **Sniffing** if available.
- Try to always disable insecure connections, but for old devices you might want to leave this be.

> **Note**
> **TCP** is generally faster (specially in an environment where GFW is dropping packets!), but **Websocket** can be configured behind CDN to hide your server IP.

## 👻 IPv6 is here!
Does enabling IPv6 really help pass the GFW blockage? Although there isn't any solid proof, I've seen it work sometimes! To do so:
1. You need three pieces: `PUBLIC_IPV6_GATEWAY`, `PUBLIC_IPV6_ADDRESS` and `IPV6_NAMESERVERS`
2. Modify `/etc/netplan/50-cloud-init.yaml` like the example below:
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
> Some parts have been hidden for my security, ignore them. The above setup first goes for IPv4 and then IPv6.

> **Warning**
> Don't choose IPv6 as your first/default route, as many ISPs don't yet support it entirely!

## ❄️ Annoying ISPs?
So [GFW](https://en.wikipedia.org/wiki/Great_Firewall) can't shut you down, but it can still make you suffer! How? By doing [Packet Drop](https://geneva.cs.umd.edu/posts/fully-encrypted-traffic/en/) on traffic heading to the outside world. To overcome this, **v2ray** supports [Tunneling](https://traefik.io/glossary/network-tunneling/):
1. Buy a server within the country, repeat the entire process of brining up X-UI on your new server.
2. Replace the configurations from `bridge-server/config.json` with the existing `XRAY Configuration` on your X-UI dashboard settings.

Tunneling looks like the following:
```
(You) <-> [ Bridge-Server ] <-> [ Upstream-Server ] <-> (Freedom)
```

> **Note**
> Use a new subdomain for your bridge-server!

## 🧱 Hide behind CDN

## 🎗️ Benchmarks

## 🤝 Issues and Contributions
Feel free to ask questions via [issue](https://github.com/keivanipchihagh/xui-trojan/issues/new) and add features by opening a [pull request](https://github.com/keivanipchihagh/xui-trojan/pulls).
