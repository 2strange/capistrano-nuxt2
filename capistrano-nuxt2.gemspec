require_relative "lib/capistrano/nuxt2/version"

Gem::Specification.new do |spec|
  spec.name        = "capistrano-nuxt2"
  spec.version     = Capistrano::Nuxt2::VERSION
  spec.authors     = ["Torsten Wetzel"]
  spec.email       = ["trendgegner@gmail.com"]
  spec.homepage    = "https://github.com/2strange/capistrano-nuxt2"
  spec.summary     = "Capistrano::Nuxt2 capistrano recipes to deploy nuxt 2 apps."
  spec.description = "TODO: Description of Capistrano::Nuxt2."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/2strange/capistrano-nuxt2"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  ## require capistrano
  spec.add_dependency       "capistrano",         ">= 3.15"
  
  ## require gems needed to deploy
  spec.add_dependency       "ed25519",            ">= 1.2", "< 2.0"
  spec.add_dependency       "bcrypt_pbkdf",       ">= 1.0", "< 2.0"

  spec.add_dependency       "capistrano-npm",     ">= 1.0"
  spec.add_dependency       "capistrano-rsync",   ">= 1.0"


end
