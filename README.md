# Capistrano::Nuxt2

Capistrano recipes to deploy nuxt 2 apps.


## Usage

prepare the server:
```sh
bundle exec cap production setup
```

deploy the app:
```sh
bundle exec cap production deploy
```

create SSL certificates:
```sh
bundle exec cap production certbot:generate
```

## Installation

Inside your **Nuxt.js project root**, run:

```sh
bundle init
```

Then, edit the `Gemfile` and add:

```ruby
source "https://rubygems.org"

gem "capistrano-nuxt2",  require: false,   github: "2strange/capistrano-nuxt2"
```

Then, install the dependencies:

```sh
bundle install
```

#### Initialize Capistrano

```sh
bundle exec cap install
```

This will generate the following files:
```
.
├── Capfile
├── config
│   ├── deploy.rb
│   ├── deploy
│   │   ├── production.rb
│   │   ├── staging.rb
│   │   ├── development.rb
│   │   └── shared.rb
├── lib
│   └── capistrano
│       └── tasks
└── ...
```

#### Add the following to your `Capfile`:

```ruby
require "capistrano/nuxt2"
## or as you want
require "capistrano/nuxt2/nuxt"
## for certbot
require "capistrano/nuxt2/certbot"
## for nginx
require "capistrano/nuxt2/nginx"
## for nginx with a proxy server
require "capistrano/nuxt2/proxy_nginx"
```

#### Add the following to your `config/deploy.rb`:

```ruby 
set :application , "my-nuxt-app"
set :repo_url, "git_path_to_your_repo"
```

#### Add the following to your `config/deploy/-STAGE-.rb`:

```ruby
server  "SERVER_DOMAIN_OR_IP",  user: "DEPLOY_USER",   roles: %w{web}

set :user,                            "DEPLOY_USER"
set :deploy_to,                       "/home/#{fetch(:user)}/#{fetch(:application)}-#{fetch(:stage)}"

set :branch,                          'STAGE_BRANCH'

## NginX
set :nginx_domains,                   ["YOUR_DOMAIN"]
set :nginx_remove_www,                true

## ssl-handling
set :nginx_use_ssl,                   true
set :certbot_email,                   "YOUR_EMAIL"

```

#### For nginx with a proxy server

```ruby

server "100.200.300.23", user: "deploy", roles: %w{app web}
server "100.200.300.42", user: "deploy", roles: %w{proxy}, no_release: true

set :user,                            "DEPLOY_USER"
set :deploy_to,                       "/home/#{fetch(:user)}/#{fetch(:application)}-#{fetch(:stage)}"

set :branch,                          'STAGE_BRANCH'

set :nginx_upstream_host,             "100.200.300.23"
set :nginx_upstream_port,             "3550"

## NginX
set :nginx_domains,                   ["YOUR_DOMAIN"]

## ssl-handling
set :nginx_use_ssl,                   true
set :certbot_email,                   "YOUR_EMAIL"

```

---

## Nuxt 3

The `nuxt3:` tasks deploy Nuxt 3 apps. Nuxt 3 builds into `.output/`
(`.output/server/index.mjs` for SSR, `.output/public/` for static assets),
not `dist/`. Two modes are supported:

- **SSR (default):** `nuxt build` → the Nitro server runs as a systemd service
  (`node .output/server/index.mjs`), with the existing proxy in front of it.
- **Static:** `nuxt generate` → `.output/public/` is synced to `shared/www`
  and served directly by nginx (no node service). Good for content sites.

Opt-in, leaves the Nuxt-2 `nuxt:` tasks untouched. Add to your `Capfile`:

```ruby
require "capistrano/nuxt2/nuxt3"
## plus proxy + certbot as needed
require "capistrano/nuxt2/proxy_nginx"
require "capistrano/nuxt2/certbot"
```

#### SSR app — `config/deploy/-STAGE-.rb`

```ruby
server "100.200.300.23", user: "deploy", roles: %w{app web}
server "100.200.300.42", user: "deploy", roles: %w{proxy}, no_release: true

set :user,                  "DEPLOY_USER"
set :deploy_to,             "/home/#{fetch(:user)}/#{fetch(:application)}-#{fetch(:stage)}"
set :branch,                'STAGE_BRANCH'

## Nuxt 3 SSR (Nitro node service)
set :nuxt3_deploy_mode,     :ssr            # default
set :nuxt3_use_nvm,         true
set :nuxt3_nvm_version,     "20.19.0"
set :nuxt3_ssr_port,        3500            # Nitro listens here (127.0.0.1)
set :nuxt3_ssr_env,         { "NUXT_PUBLIC_API_BASE" => "https://api.example.com" }

## Proxy points at the Nitro service
set :nginx_upstream_host,   "100.200.300.23"
set :nginx_upstream_port,   fetch(:nuxt3_ssr_port)

## NginX / SSL
set :nginx_domains,         ["YOUR_DOMAIN"]
set :nginx_use_ssl,         true
set :certbot_email,         "YOUR_EMAIL"
```

#### Static site — `config/deploy/-STAGE-.rb`

```ruby
server "SERVER_DOMAIN_OR_IP", user: "DEPLOY_USER", roles: %w{web}

set :user,                  "DEPLOY_USER"
set :deploy_to,             "/home/#{fetch(:user)}/#{fetch(:application)}-#{fetch(:stage)}"
set :branch,                'STAGE_BRANCH'

set :nuxt3_deploy_mode,     :static
set :nuxt3_use_nvm,         true
set :nuxt3_nvm_version,     "20.19.0"

## NginX / SSL (serves shared/www directly)
set :nginx_domains,         ["YOUR_DOMAIN"]
set :nginx_use_ssl,         true
set :certbot_email,         "YOUR_EMAIL"
```

The `deploy:published` hook rebuilds automatically per `:nuxt3_deploy_mode`.
Manage the SSR service with `cap <stage> nuxt3:ssr:{setup,activate,restart,check_status,logs}`.

**First SSR deploy** (the systemd unit doesn't exist yet, so an auto-restart
would fail — same as puma/sidekiq):

```ruby
set :nuxt3_ssr_hooks, false   # in the stage file, for the first deploy only
```

```sh
cap <stage> deploy              # builds + syncs .output (no restart)
cap <stage> nuxt3:ssr:configure # uploads + enables + starts the Nitro unit
```

Then set `nuxt3_ssr_hooks` back to `true` (the default) so subsequent deploys
restart the service cleanly.

---

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
