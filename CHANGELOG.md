# Changelog — capistrano-nuxt2

## 0.2.22 — 2026-10-15

**Deploys reißen den geteilten Proxy nicht mehr kurz runter.** Keine neue Config nötig.

- **fix (nginx, Shared-Proxy):** `nginx:proxy:update` und `nginx:app:update` (laufen bei jedem
  Deploy) haben nginx **neu gestartet** → auf einem geteilten Proxy kurz alle anderen Seiten weg.
  Jetzt `nginx -t` (kaputte Config bricht den Deploy ab, laufendes nginx behält die alte) und dann
  `systemctl reload-or-restart nginx` (reload; Start nur, falls nginx gar nicht läuft).
  Manueller Restart bleibt: `cap <stage> nginx:proxy:service:restart`. (Fund: Mary-Bob)

## 0.2.21 — 2026-10-15

**Fix: `certbot_www_domains` erzeugte kaputte certbot-Argumente.**

- **fix (certbot):** In `fetch_certbot_domain_args` fehlte das Leerzeichen vor dem
  zweiten `-d` → aus `example.com` wurde `-d example.com-d www.example.com`.
  Betrifft nur Stages mit `set :certbot_www_domains, true`; alle anderen
  rendern unverändert. (Fund: interview-Bob, 2026-10-15)

## 0.2.20 — 2026-06-16

**Setup zieht jetzt das SSL-Cert mit — „nach `cap <stage> setup` einfach deployen".**
Rein additiv; bestehende Tasks/Templates/Defaults und `server:setup` unverändert.

- **feat (Let's Encrypt im Setup):** neues Mini-Template `nginx_letsencrypt.conf.erb` +
  Task `certbot:bootstrap`. Lädt einen **minimalen ACME-only `:80`-vhost** hoch
  (nur `.well-known/acme-challenge` → `:certbot_webroot`, **kein** Upstream/SSL/
  Container-Bezug), zieht das Cert (`certbot:generate`) und entfernt den vhost
  wieder. Damit steht das Zertifikat **vor** dem ersten Deploy — kein Flag-Toggle-
  Dance, kein „Proxy wegfeuern" durch eine SSL-Config ohne Cert. Läuft auf
  `:certbot_roles` (im Proxy-Setup `[:proxy]`).
- **feat (Setup-Aggregat erweitert):** `cap <stage> setup` ruft jetzt zusätzlich
  `certbot:bootstrap` (wenn `:nginx_use_ssl`).
- **chore:** `certbot.rake` lädt explizit `base_helpers` + `nginx_helpers`
  (für `template2go`/Domain-Helper im neuen Task).
- **chore:** stales `# deprecated`-Kommentar in `version.rb` entfernt —
  capistrano-nuxt2 ist Standard für Nuxt-2-/static-Deploys (nicht deprecated).

> Nutzung pro App in `config/deploy/<stage>.rb`, z.B.:
> `set :nginx_use_ssl, true` · `set :certbot_email, "…"` ·
> `set :certbot_roles, [:proxy]` · `set :certbot_webroot, "/var/www/html"`.
