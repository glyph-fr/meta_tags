MetaTags.config do |config|
  # Default title methods to be checked for title
  #
  # config.title_methods = %w(title name)

  # Default decsription methods to be checked for description
  #
  # config.description_methods = %w(description desc content)

  # Default image methods to be checked for image
  #
  # config.image_methods = %w(image picture avatar)

  # Configure the default meta tags that will be used when no source could
  # fill the defined meta.
  #
  # One good thing is to configure the title here to avoid empty <title> tags.
  # But you can configure any supported meta tag here.
  #
  # Note that you'll need to pass a proc or lambda, and that it'll be executed
  # in the context of the controller.
  # This allows for example to set I18n aware defaults.
  #
  # config.defaults = lambda do
  #   { title: 'My website' }
  # end
end
