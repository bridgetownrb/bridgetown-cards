---
title: Adding Custom Web Fonts
description: It's very easy to add custom web fonts to your website. Here's how to do it.
twitter: jaredcwhite
github: jaredcwhite
version: 1.0
tags:
- frontend
- CSS
---

Custom fonts help a site stand out from the crowd. Adding fonts directly to your Bridgetown repo and your stylesheet is easy!

Let's say you have a web font file: `DMSerifDisplay-Regular.woff2`. What are you supposed to do with it? First, you'll need a stylesheet for your font(s).

Save a file in `frontend/fonts/dm/dm.css`:

```css
@font-face {
  font-family: "DMSerif";
  src: url("./DMSerifDisplay-Regular.woff2") format("woff2");
  font-weight: normal;
  font-style: normal;
}
```

Then copy the font file into the `dm` folder.

Finally, at the top of your `index.css` file, all you have to do is add one line:

```css
@import "../fonts/dm/dm.css";
```

Bingo! You've just added a custom font to your Bridgetown site. For more information about `@font-face` rules, [check out this guide on MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face).
