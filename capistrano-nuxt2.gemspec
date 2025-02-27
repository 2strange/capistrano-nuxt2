require_relative "lib/capistrano/nuxt2/version"

Gem::Specification.new do |spec|
  spec.name        = "capistrano-nuxt2"
  spec.version     = Capistrano::Nuxt2::VERSION
  spec.authors     = [ "Austin Strange" ]
  spec.email       = [ "strangeaustin@googlemail.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of Capistrano::Nuxt2."
  spec.description = "TODO: Description of Capistrano::Nuxt2."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.1"
end
