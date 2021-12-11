---
# Feel free to add content and custom Front Matter to this file.

layout: default
template_engine: serbea
---

<section-wrapper class="fade-in-animation" style="padding-top:3rem"><section markdown="1">

## Share what you know. <br/>Build what you learn.

**Bridgetown Cards** is a community site, for Bridgetowners, by Bridgetowners. Browse through a selection of tips & tricks, with accompanying code snippets, to help you get a leg up on your site build. And when you come up with a cool new technique, or pull in a sweet Ruby gem or neat-o NPM package, and want to share that know-how with others, this is the place to do it. Have fun! 😃

ICYMI: **Bridgetown** is a next-generation, progressive site generator & fullstack framework, powered by Ruby. [Check it out!](https://www.bridgetownrb.com)

</section></section-wrapper>

<section-wrapper style="padding-top:3rem"><section class="masonry">

{% collections.cards.resources.each do |card| %}
  <div class="masonry-item">
    <sl-card class="masonry-content">
      <div slot="header">
        <h3>{{ card.data.title | smartify }}</h3>
      </div>

      {{ card.data.description | markdownify }}
      
      <div slot="footer">
        <ui-label class="tags" style="padding-right:0.5rem">
          {%
            colors = [:success, :warning, :danger]
            i = -1
          %}
          {% card.data.tags.each do |tag| %}
            {% i == 2 ? i = 0 : i += 1 %}
            <sl-tag type="{{ colors[i] }}" size="small" pill>{{ tag }}</sl-tag>
          {% end %}
        </ui-label>
        <sl-button type="primary">
          <turbo-frame>
            <a href="{{ card.relative_url }}" data-turbo-frame="{{ card.relative_url }}">
              Read…
            </a>
          </turbo-frame>
        </sl-button>
      </div>
    </sl-card>

    <sl-dialog class="dialog-width" style="--width: min(90vw, 1400px)">
      <h3 slot="label" style="display:inline-block; margin-bottom:0; font-size:1.3em; text-align:left;">{{ card.data.title | smartify }}</h3>
      <turbo-frame id="{{ card.relative_url }}">
        <p style="margin: 4rem 0; text-align:center"><sl-spinner style="font-size: 3rem; --indicator-color: var(--color-orange); --track-color: #ffc399;"></sl-spinner></p>
      </turbo-frame>
      <sl-button slot="footer" type="primary" onclick="this.closest('sl-dialog').hide()">Return to Cards</sl-button>
    </sl-dialog>
  </div>
{% end %}

</section></section-wrapper>