
namespace :nuxt do
  desc "Install dependencies"
  task :install_dependencies do
    on roles(:web) do
      within release_path do
        execute :npm, "install"
      end
    end
  end

  desc "Build Nuxt.js app"
  task :build do
    on roles(:web) do
      within release_path do
        execute :npm, "run build"
      end
    end
  end

  desc "Export static files (if needed)"
  task :export do
    on roles(:web) do
      within release_path do
        execute :npm, "run generate"
      end
    end
  end

  desc "Sync the dist folder to the shared folder"
  task :sync_dist do
    on roles(:web) do
      execute :rsync, "-a --delete #{release_path}/dist/ #{shared_path}/www/"
    end
  end

  desc "Update and restart Nginx"
  task :update_nginx do
    on roles(:web) do
      execute :sudo, :cp, "deploy/#{fetch(:stage)}/pm2_nginx.conf", "/etc/nginx/sites-available/kdw_app_#{fetch(:stage)}"
      unless test("[ -h /etc/nginx/sites-enabled/kdw_app_#{fetch(:stage)} ]")
        execute :sudo, :ln, "-s", "/etc/nginx/sites-available/kdw_app_#{fetch(:stage)}", "/etc/nginx/sites-enabled/kdw_app_#{fetch(:stage)}"
      end
      execute :sudo, "/etc/init.d/nginx restart"
    end
  end

  desc "Fix permissions (just in case)"
  task :fix_permissions do
    on roles(:web) do
      execute :sudo, :chown, "-R #{fetch(:user)}:#{fetch(:user)} #{release_path}"
    end
  end

  after "deploy:published", "deploy:install_dependencies"
  after "deploy:install_dependencies", "deploy:build"
  after "deploy:build", "deploy:export"
  after "deploy:export", "deploy:sync_dist"
  after "deploy:sync_dist", "deploy:update_nginx"
  after "deploy:update_nginx", "deploy:fix_permissions"
end
