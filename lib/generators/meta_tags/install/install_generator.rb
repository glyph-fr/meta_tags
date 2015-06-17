module MetaTags
  class InstallGenerator < Rails::Generators::Base
    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    # Generator desc
    desc "Meta-tags install generator"

    def copy_initializer_file
      copy_file "initializer.rb", "config/initializers/meta_tags.rb"
    end

    def copy_migrations
      rake "meta_tags_railtie:install:migrations"
    end
  end
end
