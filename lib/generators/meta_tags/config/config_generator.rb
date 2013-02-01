module MetaTags
  class ConfigGenerator < Rails::Generators::Base
    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    # Generator desc
    desc "Meta-tags config generator"

    def welcome
      say "Configuring Meta-tags dependencies and files !"
    end

    def copy_initializer_file
      say "Installing default initializer template"
      copy_file "initializer.rb", "config/initializers/meta_tags.rb"
    end
  end
end