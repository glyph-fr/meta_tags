# Meta_tags

Meta tags allows a Rails application to include meta tags in HTML, depending on the action. Content can be set by I18n locales, Models or defined in ApplicationController.

## Installing

1. Add this line to your Gemfile
```ruby
gem 'meta_tags', git: "git://github.com/vala/meta_tags.git"
```

2. Generate config file :
```bash
rails generate meta_tags:config
```

## Defining default values
### In your ApplicationController
```ruby
gem 'meta_tags', git: "git://github.com/vala/meta_tags.git"
```

### In your locales
```yaml
en:
  meta_tags: 
    controller:
      posts: 
        index: 
          title: Test
          description: Test description
```

### In a Controller
You can use the helper meta_tags_from to use data from the associated model
<tt>app/controllers/posts_controller.rb</tt>
```ruby
class PostsController < ApplicationController
  meta_tags_from :post

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
```

<tt>app/models/post.rb</tt>
```ruby
class Post < ActiveRecord::Base
  attr_accessible :description, :tags, :title, :image
  has_attached_file :image
end
```

Used methods can be defined in the initializer <tt>config/initializers/meta_tags.rb</tt>
```ruby
MetaTags.config do |config|

  # Default title methods to be checked for title
  # config.title_methods = %w(title name)

  # Default decsription methods to be checked for description
  # config.description_methods = %w(description desc)

  # Default description methods to be checked for description
  # config.image_methods = %w(image picture avatar)
end
```


### Overwrite in a controller
```ruby
class HomeController < ApplicationController
  def index
    set_meta_tag(:title, "Accueil")
  end
end
```

## View helper
```haml
!!!
%html
  %head
    = stylesheet_link_tag "application"
    = meta_tags
```
