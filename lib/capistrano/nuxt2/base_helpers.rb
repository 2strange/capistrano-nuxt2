require 'erb'
require 'stringio'

module Capistrano
  module Nuxt2
    module BaseHelpers

      def build_deploy_env_var
        app_name = fetch(:application).gsub(/ /,'_').gsub(/-/,'_').upcase
        stage_name = fetch(:stage) == 'production' ? 'PROD' : 'STG'
        "#{ app_name }_#{ stage_name }_DEPLOY_MODE"
      end

      ## PAth helpers
      def ensure_shared_path(path)
        unless test("[ -d #{path} ]")
          puts "📂 Directory #{path} does not exist. Creating it..."
          execute :mkdir, "-p", path
        else
          puts "✅ Directory #{path} already exists."
        end
        ensure_shared_path_ownership
      end

      def ensure_shared_www_path
        ensure_shared_path("#{shared_path}/www")
      end

      def ensure_shared_path
        ensure_shared_path("#{shared_path}")
      end

      def ensure_shared_path_ownership
        # Fix ownership only if needed (avoids unnecessary chown operations)
        unless test("stat -c '%U:%G' #{shared_path} | grep #{fetch(:user)}:#{fetch(:user)}")
          puts "🔧 Fixing ownership of #{shared_path} and its parent directories..."
          execute :sudo, :chown, "-R #{fetch(:user)}:#{fetch(:user)} #{shared_path}"
          execute :sudo, :chown, "#{fetch(:user)}:#{fetch(:user)} #{fetch(:deploy_to)}"
        else
          puts "✅ Ownership is already correct."
        end
      end



      def template2go(from, to)
        erb = get_template_file(from)
        upload! StringIO.new( ERB.new(erb).result(binding) ), to
      end
      
      
      def render2go(tmpl)
        erb = get_template_file(tmpl)
        ERB.new(erb).result(binding)
      end
      

      def template_with_role(from, to, role = nil)
        erb = get_template_file(from)
        upload! StringIO.new(ERB.new(erb).result(binding)), to
      end
      
      
      def get_template_file( from )
        [
            File.join('config', 'deploy', 'templates', "#{from}.erb"),
            File.join('config', 'deploy', 'templates', "#{from}"),
            File.join('lib', 'capistrano', 'templates', "#{from}.erb"),
            File.join('lib', 'capistrano', 'templates', "#{from}"),
            File.expand_path("../../../generators/capistrano/nuxt2/templates/#{from}.erb", __FILE__),
            File.expand_path("../../../generators/capistrano/nuxt2/templates/#{from}", __FILE__)
        ].each do |path|
          return File.read(path) if File.file?(path)
        end
        # false
        raise "File '#{from}' was not found!!!"
      end
      
      
    end
  end
end




