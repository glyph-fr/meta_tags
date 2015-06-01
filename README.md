# Meta tags

This gem allows for setting and retrieving HTML meta tags for SEO and URL
sharing optimization.

## Installing

Add the gem to your Gemfile

```ruby
gem 'meta_tags', git: "git://github.com/vala/meta_tags.git"
```

Run the install generator :

```bash
rails generate meta_tags:install
```

## Usage

There are multiple ways to define meta tags for your pages.

In the following section, you'll find how to :

1. Display the meta tags in your pages
2. Define default values for the application
3. Manually set meta tags in your controller
4. Retrieve meta tags from models
5. Automatically retrieve meta tags from locale files
6. Store meta tags in the database to allow the webmasters edit them

### 1. Display the meta tags in your pages

Simply call the `meta_tags` method in your layout file :

```erb
<html>
  <head>
    <%= meta_tags %>
    ...
  </head>
  <body>
    ...
  </body>
</html>
```

If you need to generate `Open Graph` or `Twitter cards` meta tags, your can
use the `:vendors` option :

```erb
<%= meta_tags vendors: [:open_graph, :twitter]
```

This will generate the appropriate meta tags for optimizing the sharing preview
on both Facebook and Twitter platforms, and all the Open Graph compliant ones.

### 2. Define default values for the application

To define default values, set the `config.defaults` inside the generated
initializer at : `config/initializers/meta_tags.rb` :

```ruby
MetaTags.config do |config|
  config.defaults = lambda do
    { title: 'My website' }
  end
end
```

### 3. Manually set meta tags in your controller

From a controller instance, i.e. a hook or action, you can use the
`set_meta_tag` helper, which allows you to set each meta tag, one by one.

This is the most manual way of doing it, and is often used when no SEO tools
are given to the webmasters, and the more automatic solutions do not match
for your use case.

```ruby
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])

    set_meta_tag(:title, @post.title)
    set_meta_tag(:description, @post.excerpt)
    set_meta_tag(:image, @post.image.url(:thumb))
  end
end
```

### 4. Retrieve meta tags from models

Meta tags can try to guess meta tags from your model, using the following
helper in a controller instance :

```ruby
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])

    meta_tags_from(@post)
  end
end
```

This will try to build the _title_, _description_ and _image_ tags from the
model.

For that to work, a certain number of methods are tried on the model.
Those methods are configurable in the initializer file.
Defaults are as follow :

```ruby
config.title_methods = %w(title name)
config.description_methods = %w(description desc content)
config.image_methods = %w(image picture avatar)
```

### 5. Automatically retrieve meta tags from locale files

You can set the meta tags from the locales with the the structure of
`meta_tags.controller.<controller_name>.<action_name>.<tag_name>` :

```yaml
en:
  meta_tags:
    controller:
      posts:
        index:
          title: "My blog"
          description: "Fresh posts from my super blog"
```

### 6. Store meta tags in the database to allow the webmasters edit them

Meta tags comes with a simple meta tags container model built-in :
`MetaTags::List`, which contains the following fields :

- meta_title
- meta_description
- meta_keywords

You can make a model meta taggable by adding the `acts_as_meta_taggable` macro
to your model :

```ruby
class Post < ActiveRecord::Base
  acts_as_meta_taggable
end
```

You'll the be able to edit meta tagged data linked to your resource in
your admin form :

```erb
<%= form_for(@post) do |form| %>
  <%= fields_for(:meta_tags_list) do |fields| %>
    <%= form.text_field :meta_title %>
    <%= form.text_area :meta_description %>
    <%= form.text_area :meta_keywords %>
  <% end %>
<% end %>
```

The to retrieve the meta tags in your controller, you cas use the
`set_meta_tags_from_list` helper :

```ruby
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])

    set_meta_tags_from_list(@post.meta_tags_list)
  end
end
```

#### Managing meta tags not bound to a resource

For the pages that don't map with resource 1 to 1, index and home pages for
example, you can manually generate models with an identifier.

In a seeds file :

```ruby
MetaTags::List.create!(name: 'Home page', identifier: 'home')
```

In your admin panel, you can list all non-resource meta tags lists with the
`without_meta_taggable` scope, to create a dedicated admin panel :

```
@meta_tags = MetaTags::List.without_meta_taggable
```

Then in your controllers, retrieve them with their identifier :

```
class HomeController < ApplicationController
  def index
    set_meta_tags_from_list(:home)
  end
end
```

