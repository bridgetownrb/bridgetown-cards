---
title: Display Money Values as Formatted Currency
description: Any time you deal with e-commerce data, you need to display money. Thankfully, there's a straightforward way to do it in Ruby.
twitter: jaredcwhite
github: jaredcwhite
version: 1.0
tags:
- Liquid
- ERB
---

_Tired:_

```liquid
Buy {{ product.data.title }} for ${{ product.data.price }}
```

_Wired:_

```liquid
Buy {{ product.data.title }} for {{ product.data.price | money }}
```

#### Use the Money gem for fun and profit!

You need an easy way to format money. Thankfully, it's more straightforward than you might think!

First, run `bundle add money` to add the Money gem to your Gemfile.

Next, save the following plugin to your site repo:

```ruby
# plugins/builders/money.rb

require "money"

Money.locale_backend = :i18n
Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN

class Builders::Money < SiteBuilder
  def build
    liquid_filter :money
    helper :money
  end

  def money(input, currency = "USD")
    Money.new(input ? input * 100 : 0, currency).format
  end
end
```

Now in any Liquid or Ruby template, you can simply use the `money` helper to format a number or string value in its proper currency! Feel free to change the default currency as needed in the method, or you can specify it in real-time: `{{ product.date.price | money: "EUR" }}` (or in ERB: `<%= money(product.data.price, "EUR") %>`).