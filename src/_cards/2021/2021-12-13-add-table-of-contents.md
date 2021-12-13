---
title: Add a Table of Contents to Your Markdown Page
description: If you have a long Markdown page and would like a simple way to navigate to various points of interest, here's a helper which can't be beat.
twitter: jaredcwhite
github: jaredcwhite
version: 1.0
tags:
- Liquid
- ERB
- Markdown
---

Bridgetown's Markdown converter is called [Kramdown](https://kramdown.gettalong.org), and it sports a variety of cool features—one of which is the ability to generate a table of contents based on headings throughout the content of a Markdown file. But the way to do that is a little [non-obvious](https://kramdown.gettalong.org/converter/html.html#toc). Let's create a Liquid tag/Ruby helper for that!

```ruby
class Builders::Toc < SiteBuilder
  def build
    liquid_tag "toc", :toc_template
    helper "toc", :toc_template
  end

  def toc_template(*)
    <<~MD
      ## Table of Contents
      {:.no_toc}
      * …
      {:toc}
    MD
  end
end
```

This will add a Table of Contents heading which itself won't show up in the TOC, and then use Kramdown's special syntax to generate the TOC. Now you can use `{% toc %}` (Liquid), `<%= toc %>` (ERB), or `{%= toc %}` (Serbea) to place your TOC anywhere in a Markdown file.

**Tip:** If you'd rather have your TOC be numbered instead of just bullet points, use `1.` instead of `*` for the blank list.
