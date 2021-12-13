---
# Feel free to add content and custom Front Matter to this file.

layout: default
template_engine: serbea
image: "https://mugshotbot.com/m?theme=bold&mode=light&color=246e62&pattern=bank_note&hide_watermark=true&url=https%3A%2F%2Fbridgetown.cards"
---

<section-wrapper class="fade-in-animation" style="padding-top:3rem"><section markdown="1">

<p class="heading-icon">
  <sl-icon library="remixicon" name="system/share-box-fill"></sl-icon>
</p>

## Share what you know. <br/>Build what you learn.
{:.serif .colorful}

**Bridgetown Cards** is a community site, for Bridgetowners, by Bridgetowners. Browse through our selection of tips & tricks, with accompanying code snippets, to help you get a leg up on your site build. Then when you come up with a cool new technique or pull in a sweet Ruby gem or neat-o NPM package, and want to share that know-how with others, this is the place to do it. Have fun! 😃

ICYMI: **Bridgetown** is a next-generation, progressive site generator & fullstack framework, powered by Ruby. [Check it out!](https://www.bridgetownrb.com)

<p style="text-align:center; margin-top:2rem">
  <sl-button href="https://github.com/bridgetownrb/bridgetown-cards" type="warning" outline>
    <sl-icon slot="prefix" library="remixicon" name="development/code-box"></sl-icon>
    Submit Your Own Card…
  </sl-button>
</p>

</section></section-wrapper>

<section-wrapper style="padding-top:1rem"><section class="masonry">

{%@ "index_cards" %}

</section></section-wrapper>