# x-ui
I'll explain how to setup the popular **v2ray** platform to bypass *almost* any [GFW](https://en.wikipedia.org/wiki/Great_Firewall) like a knife through butter. If you like the project and found it helpful, please do star and share with others!

> **Note**
> The following instructions require some technical background on Linux, Docker, Certificates and some concepts about VPNs in general. If you have any questions or suggestions, feel free to open an [Issue](https://github.com/keivanipchihagh/x-ui/issues/new) or a Pull request.

## Table of Contents
- 💫 [First things first](https://github.com/keivanipchihagh/x-ui#-first-things-first)
- 🪖 [(Optional) Hold on to your Firewalls!](https://github.com/keivanipchihagh/x-ui#-optional-hold-on-to-your-firewalls)
- 🐳 [Run it with Docker!](https://github.com/keivanipchihagh/x-ui#-run-it-with-docker)
- 🚀 [Let the dashboard, Begin!](https://github.com/keivanipchihagh/x-ui#-let-the-dashboard-begin)
- 🗝️ [SSL is everywhere](https://github.com/keivanipchihagh/x-ui#-ssl-is-everywhere)
- 📬 [Your First Inbound](https://github.com/keivanipchihagh/x-ui#-your-first-inbound)
- 👻 [IPv6 is here!](https://github.com/keivanipchihagh/x-ui#-ipv6-is-here)
- ❄️ [(Optional) Tunneling](https://github.com/keivanipchihagh/x-ui#-tunneling)
- 🚅 [Faster TCPs](https://github.com/keivanipchihagh/x-ui#-faster-tcps)
- 🧱 [Take Cover behind CDN](https://github.com/keivanipchihagh/x-ui#-take-cover-behind-cdn)
- 🎗️ [Benchmarks](https://github.com/keivanipchihagh/x-ui#-benchmarks)
- ❓ [Q&A](https://github.com/keivanipchihagh/x-ui#-qa)
- 🤝 [Issues and Contributions](https://github.com/keivanipchihagh/x-ui#-issues-and-contributions)
- 📖 [Credits](https://github.com/keivanipchihagh/x-ui#-credits)

## 💫 First things first
1. You need a *domain*! You can purchase one from [parspack](https://parspack.com/), [parshost](https://billing.pars.host/hosting/login), [pulseheberg](https://pulseheberg.com/en/) (recommended) or from [NameCheap](https://education.github.com/pack/offers#namecheap) if you have [GitHub Student Pack](https://education.github.com/pack). Just don't go with ***.ir*** for your own sake!!!
2. Buy a VPS Server with *minimum* hardware requirements and nothing too fancy. Make sure the server is located outside our beloved country 😘
3. Create a [Cloudflare](https://cloudflare.com/) account and register your domain. It can take up to 24 hours to fully settle in, so be patient.
4. Once done, map a subdomain to your server IPv4 (Leave proxied *unchecked!*). This can take a few minutes to take effect. Check availability with [dnschecker](https://dnschecker.org/).

> **Note**
> There is no need to set any *NS* records if you just want a vanilla VPN, but we will need them later on when working with Cloudflare workers.

## 🪖 (Optional) Hold on to your Firewalls!
I always enjoy the extra security on my servers. If you enjoy it too, run `scripts/ufw.sh` to configure a minimal Firewall with default policies (allows ports **22**, **80**, **443** and **54321** for X-UI dashboard).

> **Warning**
> With firewall enabled, you must allow each X-UI inbound port in firewall after you create it, or you won't be able to connect!

## 🐳 Run it with Docker!
[Docker](https://www.docker.com/) is the perfect wrapper for VPNs since it's clean and easy-peasy to setup stuff with. Install Docker by running the `scripts/docker.sh` script.

> **Note**
> The script will install *Docker Engine*, *docker-compose* and add them to sudo group.

## 🚀 Let the dashboard, Begin!
1. There is a file called `.env.template` which containes placeholders for variables that you must change to your liking. Afterwards, rename the file to `.env`.
2. Make sure nothing is blocking port **80** and **443** (like NGINX) until the end of this section. If there is any process using it at the time, stop it temporarily.
3. Run the `build.sh` script which generates a free SSL certificate using [CertBot](https://certbot.eff.org/) and deploys the **X-UI** container.
4. All done! Access your dashboard via `<SERVER-IP>:<DASHBOARD-PORT>` where the default dashboard port is `54321`.

> **Warning**
> SSL certificate generation will fail if the **DOMAIN** in `.env` does not match the one setup in Cloudflare!

> **Warning**
> The default username and password for the dashboard are "**admin**". Change them immediately and thank me later!

## 🗝️ SSL is everywhere
You can access your dashboard via `<SERVER-IP>:<DASHBOARD-PORT>` or connect to your inbounds without any TLS encryption, but that leaves you exposed! To enable SSL on your dashboard:
1. On your [Cloudflare](https://cloudflare.com/) account, set the *SSL/TLS* level to `strict` or beyond.
2. Navigate to **Panel Settings** and change the following fields (replace `DOMAIN` with your own):
    - Panel *certificate.crt* file path: `/etc/letsencrypt/live/{DOMAIN}/fullchain.pem`
    - Panel *private.key* file path: `/etc/letsencrypt/live/{DOMAIN}/privkey.pem`

From now on, always access your dashboard via `<DOMAIN>:<DASHBOARD-PORT>` which is secure! Good for you.

## 📬 Your First Inbound
Inbounds are for different configurations and protocols, not for every user. You can make infinite number of users on a single Inbound. Now create an Inbound with the following configurations:
- Protocol: `Trojan`
- Port: `<WHATEVER_JUST_ALLOW_IT_IN_YOUR_FIREWALL_AS_WELL>`
- Disable insecure encryption: `True`
- Transmission: `TCP`
- TLS: `True`
- *certificate.crt* file path: `/etc/letsencrypt/live/{DOMAIN}/fullchain.pem`
- *private.key* file path: `/etc/letsencrypt/live/{DOMAIN}/privkey.pem`
- Sniffing: `True`

If your certificates are generated correctly, the configurations above will connect on most ISPs. However keep in mind a few things:
- Stick with `XTLS` rather than `TLS` if at all possible.
- Always add `Certificate.crt` and `Private.key` paths for each inbound and enable `TLS`, otherwise you are walking naked on the Internet! I mean it..
- Enable `Sniffing` if available.
- Always enable `Disable insecure connections`.

> **Note**
> You can twist and change the configuration to see what works best for you.

## 👻 IPv6 is here!
Enabling IPv6 will help connect to some ISPs. For that, you need an IPv6 first which you can get from your server provider.

1. You need three pieces: `PUBLIC_IPV6_GATEWAY`, `PUBLIC_IPV6_ADDRESS` and `IPV6_NAMESERVERS`
2. Set your servers `PUBLIC_IPV6_ADDRESS` with *AAA* record into Cloudflare and point it to your **DOMAIN**.
3. Modify `/etc/netplan/50-cloud-init.yaml` like the example below:
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

## ❄️ (Optional) Tunneling
[Tunneling](https://traefik.io/glossary/network-tunneling/) is a nice way to bypass most GFWs on most ISPs. The idea is to not directly connect to your "upstream server" anymore, but to connect to an intermediate server (within you own country and inside a big known data center) that we call a "bridge server" that acts as a tunnel for your traffic. Curious why this method works? Learn more in the [Q&A](https://github.com/keivanipchihagh/x-ui/tree/main#why-does-tunneling-work).
However there are some things worth mentioning:
- 💵 This method is costly, because you now have two servers to pay for!
- 🚀 Your speed fairly improves, but might become volatile at times.
- ⛔ This method is advanced, risky and tricky. Approach it only if you know what you are doing!

Those being said:
1. Buy a server within the country and inside a known data center, repeat the entire process of brining up X-UI on your new server. (Use a new `<DOMAIN>`)
2. Create an inbound on your upstream-server (`Websocket` for stable connection) with `TLS` enabled as always.
3. Replace the configurations from `v2ray/bridge-server.json` with the existing `XRAY Configuration` on your X-UI dashboard settings (Change spesific parts accoring to your upstream inbound).

## 🚅 Faster TCPs
Google's upgraded congestion control algorithms will slightly improve your *TCP* connections speed. To apply it on your system, run the `scripts/bbr.sh` script.

## 🧱 Take Cover behind CDN
Your VPN works fine 🍻 and you are happy 😃. However, your server IP is still exposed and *-let me guess-* your VPN doesn't work on some ISPs. If you are unlucky enough, your IP will be blocked on other ISPs in the matter of weeks. This is where CDN comes into play and hides your real IP with a Cloudflare IP. Why don't GFWs block the Cloudflare itself? Learn more in [Q&A](https://github.com/keivanipchihagh/x-ui/tree/main#why-doesnt-gfws-block-cloudflare).

Make sure your VPN does indeed work before following the next procedure:
1. On Cloudflare, turn on *Strict SSL/TLS*.
2. Create a new Inbound with the following configurations:
    - Protocol: `vmess` or `vless`
    - Port: `443`
    - Transmission: `ws` (`TCP` and `UDP` transmission methods no longer with with CDN)
    - TLS: `True` (Add certificates)
3. On Cloudflare, turn on proxied for both IPv4 and IPv6.
4. Ping your `<DOMAIN>` and see if the IP changes. This can take a few minutes to settle in.

## 🎗️ Benchmarks
I'm too old for this shit.

## ❓ Q&A
### What does GFW do behind the scene?
They do [Packet Drop](https://geneva.cs.umd.edu/posts/fully-encrypted-traffic/en/).
### Why does Tunneling work?
Two simple reasons. First, GFWs are more interested in the traffic heading outside the country. By tunneling, your traffic moves internally half the way. Second, Data Centers are off limit for GFWs, because there are hundreds or thousands of servers running in them that belong to big-ass companies! They wouldn't want to mess with that, huh? If your server is within the same data center as those companies, you get the VIP luxury of high speed and no GFW 🚬😎
### Why doesn't GFWs block Cloudflare?
Almost all companies are using Cloudflare now. Blocking you will block them as well! However, this doesn't mean not messing around with Cloudflare traffic.

## 🤝 Issues and Contributions
Feel free to ask questions via [issue](https://github.com/keivanipchihagh/xui-trojan/issues/new) or add your creative ideas by opening a [pull request](https://github.com/keivanipchihagh/xui-trojan/pulls).

## 📖 Credits
- [BBR Script](https://github.com/teddysun/across) - The script that makes TCP go kaboom
- [X-UI Image](https://hub.docker.com/r/enwaiax/x-ui) - The English version of the X-UI Image
