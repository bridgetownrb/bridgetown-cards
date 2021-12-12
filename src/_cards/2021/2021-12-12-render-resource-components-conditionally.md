---
title: Render Resource Components Conditionally
description: Want to render multiple categories or across multiple collections? Use a component hierarchy!
twitter: jaredcwhite
github: jaredcwhite
version: 1.0
tags:
- resources
- ERB
- Serbea
---

{% raw %}

**Note:** this technique requires that you use ERB or [Serbea](https://www.serbea.dev) as your template language. [Here's information on how to use Ruby components in Brigdgetown.](https://www.bridgetownrb.com/docs/components/ruby)

Let's first look at the scenario where you'd like to display a resource differently depending on the category it's in. The naïve way to do it would be to add a conditional to your template directly and render different components accordingly:

```erb
<!-- ERB -->
<% if resource.data.category == "category1" %>
  <%= render Category1Resource.new(resource: resource) %>
<% elsif resource.data.category == "category2" %>
  <%= render Category2Resource.new(resource: resource) %>
<% end %>
```

```serbea
<!-- Serbea -->
{% if resource.data.category == "category1" %}
  {%@ Category1Resource resource: resource %}
{% elsif resource.data.category == "category2" %}
  {%@ Category2Resource resource: resource %}
{% end %}
```

Obviously that gets pretty messy pretty fast, and while you could wrap it up in its own partial to avoid duplication, it's not "elegant". There's also the conundrum where each component might want to make use of reusable logic, and if they're all one-off components, that's not easily feasible. Let's instead look at a more maintainable solution.

#### Creating Your Base Component

What we need is a base class which is responsible for providing the relevant subclass for a particular type of resource. Any shared logic between resource types can be placed here in the base class. It might look something like this:

```ruby
# src/_components/resources/base_component.rb

module Resources
  class BaseComponent < Bridgetown::Component
    attr_reader :resource, :h_level, :show_thumbnail

    class << self
      def component_for_resource(resource)
        case resource.data.category
        when "articles"
          ArticleComponent
        when "pictures"
          PictureComponent
        when "links"
          LinkComponent
        when "thoughts"
          ThoughtComponent
        when "videos"
          VideoComponent
        end
      end
    end

    def initialize(resource:, h_level: :h2, show_thumbnail: false)
      @resource, @h_level, @show_thumbnail = resource, h_level, show_thumbnail
    end
  end
end
```

This is copied verbatim from [my own site codebase](https://github.com/jaredcwhite/jaredwhite_website/blob/main/src/_components/resources/base_component.rb). What's happening here is we define a class method called `component_for_resource`. It examines the resource's category and returns the relevant component class. If you wanted to look at collections, instead of categories, you could write `case resource.collection.label`.

This class also defines an `initialize` method that's common across all subclasses. Since the code in a template would instantiate any of the subclasses in the same manner, there's no opportunity for a subclass to define its own unique initializer.

Now let's look at one of the subclasses:

```ruby
# src/_components/resources/article_component.rb

module Resources
  class ArticleComponent < BaseComponent
  end
end
```

Whoa, that's it?! Yes, for the most part all your subclasses won't do anything special on the Ruby side. On the component template side, of course they'll all be different. (You'd have `article_component.(erb|serb)`, `link_component.(erb|serb)`, etc.) However, in cases where you want commonality between the various component templates, they in turn can render a shared component! For example, I also have a `PublishedDateComponent` which renders out the date when the resource was published, and that component is rendered out by the article template, the picture template, the thought template, etc.

#### Rendering the Right Component via the Base Class

Now that you have your base class and subclasses set up, here's how you render the relevant component for a resource:

```erb
<!-- ERB -->
<%= render Resources::BaseComponent.component_for_resource(resource).new(resource: resource) %>

<!-- or in another setting: -->
<%= render Resources::BaseComponent.component_for_resource(resource).new(resource: resource, h_level: :h3, show_thumbnail: true) %>
```

```serbea
<!-- Serbea -->
{%@ Resources::BaseComponent.component_for_resource(resource) resource: resource %}

<!-- or in another setting: -->
{%@ Resources::BaseComponent.component_for_resource(resource) resource: resource, h_level: :h3, show_thumbnail: true %}
```

The first part of the method call is `Resources::BaseComponent.component_for_resource(resource)`. This passes the resource to the `component_for_resource` method which you saw defined above, and the return value is a specific component class. That component class in turn is instantiated with the resource, and possibly other optional keyword arguments.

One potential gotcha to be aware of if there's no matching category or collection, the above code as written would raise an error since the `new` method would be called on `nil`. You could fix this by adding a `UnknownComponent` subclass and returning that in an `else` clause within the `case` statement. Then you'd just need to figure out what `UnknownComponent` renders in its template. An exercise left for the reader!

{% endraw %}
