---
title: Use Turbo Frames to Load Modal Content
description: This very technique is used on this website! How can a static site serve the same content for inside a modal as well as a standalone page simultaneously?! Find out how in this card.
twitter: jaredcwhite
github: jaredcwhite
version: 1.0
tags:
- Turbo
- Shoelace
---

{% raw %}

When you click on a **Read** button to bring up a card on this website, the content is loaded asynchronously inside the modal dialog that pops up. You'd be forgiven for assuming that specific chunk of HTML is served verbatim from the server. But if you actually look at the request/response in your dev tools, you'll discover it's sending the exact same HTML over the wire as if you went to that URL directly (and you can!)—including _all_ of the HTML layout, the HTML `<head>`, etc.

How is this possible? Well it's all thanks to a little [Hotwire](https://hotwired.dev) magic…Turbo specifically. You can easily add Turbo to your own site by running `bin/bridgetown configure turbo`. But it's not always immediately apparent what you can actually **do** with Turbo once you've installed it. So let's break this all down, shall we?

#### Creating the Layout

Card resources are part of the `cards` collection. (Gee, that's original!) Cards are assigned to the `card` layout automatically through the use of a `_defaults.yml` file in `src/_cards` containing `layout: card`. So far, so good.

In this layout, there's the usual HTML to add things like a page title, and a link button at the bottom to return to the homepage. But there's something peculiar in the middle: the bulk of the content is _wrapped_ inside of a `turbo-frame` tag. Not only that, but the tag's ID is the relative URL of the card resource itself. It looks something like this (condensed for brevity):

```serbea
<section>

  <h2>{{ resource.data.title | smartify }}</h2>

  <turbo-frame id="{{ resource.relative_url }}" target="_top">
    <!-- bits of content here -->
    {%= yield %}
  </turbo-frame>

  <p><a href="/">Return</a></p>

</section>
```

On a full page load of this layout, the `<turbo-frame>` tag is "inert", it doesn't really do anything for us. In fact, we want to disable the default Turbo Frame behavior by setting `target` to `_top` (which means links/form submissions won't be trapped inside the frame). The real exciting aspect of this tag won't kick until our next step.

#### Setting Up the Dialog

We want to have a modal dialog box which can load the contents of the Turbo Frame inside its body. We'll pull in the ever-helpful [Shoelace library](https://shoelace.style) and use its `<sl-dialog>` component to accomplish this. We can even add a spinner which will show until the frame contents load.

As we loop through our card resources on the homepage, we'll add dialog skeletons which can hold the incoming content. Let's take a look at how this works (again, condensed for brevity):

```serbea
<sl-dialog>
  <h3 slot="label">{{ card.data.title | smartify }}</h3>

  <turbo-frame id="{{ card.relative_url }}" target="_top">
    <p><sl-spinner></sl-spinner></p>
  </turbo-frame>

  <sl-button slot="footer" type="primary" onclick="this.closest('sl-dialog').hide()">
    Return
  </sl-button>
</sl-dialog>
```

So far, so good. There's now a dialog ready to open up at the opportune time, and it contains a Turbo Frame with the same ID as the one which will load in from a card resource layout. _But, er, how do we trigger this dialog to open?_ And how do we get that frame to load the content?

#### Activating the Button

As we loop through the cards collection, we render literal `<sl-card>` components—courtesy of Shoelace. In the footer of the card, there's a "Read" button. It looks something like this:

```serbea
<sl-button type="primary">
  <turbo-frame>
    <a href="{{ card.relative_url }}" data-turbo-frame="{{ card.relative_url }}">
      Read…
    </a>
  </turbo-frame>
</sl-button>
```

It seems a bit strange to have a Turbo Frame without an ID encompassing an anchor tag, but this is where the magic happens. By wrapping the link in a frame and giving the link a `data-turbo-frame` attribute (which is itself the relative URL of the card resource), it's telling Turbo: _please request this href, find a frame with the specified ID in the response, and load it up inside the existing frame on this page with the same ID_. It's spooky action at a distance—links in one frame affecting content in a different frame. But this is totally permitted, encouraged even, by Turbo!

As far as opening the dialog to display the frame content, we have an extra bit of JavaScript in our `index.js` file which handles that, as well as makes sure button clicks trigger the link (since Shoelace's button has extra padding around the `a` tag):

```js
window.addEventListener("turbo:load", () => {
  document.querySelectorAll("sl-card sl-button").forEach(button => {
    button.addEventListener("click", e => {
      e.currentTarget.closest('.masonry-item').querySelector('sl-dialog').show()

      if (e.target.localName != "a") {
        const anchor = e.currentTarget.querySelector("a")
        if (anchor) anchor.click()
      }
    })
  })
})
```

(In case you're wondering, `.masonry-item` is a div tag which wraps both the `sl-card` and `sl-dialog` tags, so it's an easy way to climb up the tree and find the relevant dialog to show.)

That is truly the only custom JavaScript needed. Everything else in the navigation flow is handled directly by Turbo.

**So to recap:**

Each card on the homepage has a "Read" button. When you click on it, the link inside the button's frame tells the frame in the nearby dialog box to load content from the card's content URL. While that response is in fact a complete HTML layout, _only the content within the matching frame ID_ is loaded into the dialog's frame. The dialog opens, and right away you see the content appear. Yet if you were to open the card resource URL in a new tab, you'd see a regular page with that same content. **Magic!**

You can inspect all of this code in action [in the Bridgetown Cards repo](https://github.com/bridgetownrb/bridgetown-cards). I hope it helps provide inspiration for your own interesting Turbo navigation flows!

{% endraw %}
