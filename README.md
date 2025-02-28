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
require "capistrano/nuxt2/certbot"
require "capistrano/nuxt2/nginx"
require "capistrano/nuxt2/nuxt"
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

---

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
