import '@shoelace-style/shoelace/dist/themes/light.css'
import '@shoelace-style/shoelace/dist/components/alert/alert.js'
import '@shoelace-style/shoelace/dist/components/button/button.js'
import '@shoelace-style/shoelace/dist/components/card/card.js'
import '@shoelace-style/shoelace/dist/components/dialog/dialog.js'
import '@shoelace-style/shoelace/dist/components/form/form.js'
import '@shoelace-style/shoelace/dist/components/icon/icon.js'
import '@shoelace-style/shoelace/dist/components/input/input.js'
import '@shoelace-style/shoelace/dist/components/tag/tag.js'
import [ register_icon_library ], from: '@shoelace-style/shoelace/dist/utilities/icon-library.js'
import [ set_animation ], from: '@shoelace-style/shoelace/dist/utilities/animation-registry.js'

import "*", as: Turbo, from: "@hotwired/turbo"

import smoothscroll from 'smoothscroll-polyfill'
# kick off the polyfill!
smoothscroll.polyfill()

import "index.css"

import components from "bridgetownComponents/**/*.{js,jsx,js.rb,css}"

register_icon_library('remixicon', 
  resolver: -> name do
    match = name.match(/^(.*?)\/(.*?)(-(fill))?$/)
    match[1] = match[1].char_at(0).upcase() + match[1].slice(1)
    "https://cdn.jsdelivr.net/npm/remixicon@2.5.0/icons/#{match[1]}/#{match[2]}#{match[3] || '-line'}.svg";
  end,
  mutator: -> svg { svg.set_attribute('fill', 'currentColor') }
)

# async def testimports()
#   foobar = await import("./foobar.js.rb")
#   puts foobar

#   foobar.default().new.do_stuff()
# end

window.add_event_listener "turbo:load" do
  document.query_selector_all("sl-card sl-button").each do |button|
    button.add_event_listener "click" do |e|
      # testimports()

      e.current_target.closest('.masonry-item').query_selector('sl-dialog').show()

      if e.target.local_name != "a"
        anchor = e.current_target.query_selector("a")
        anchor.click() if anchor
      end
    end
  end

  # Change the animation for odd numbered dialogs
  document.query_selector_all(".masonry-item:nth-child(odd) sl-dialog").each do |dialog|
    set_animation(dialog, 'dialog.show',
      keyframes: [
        { transform: 'rotate(-5deg) scale(0.6)', opacity: '0' },
        { transform: 'rotate(0deg) scale(1)', opacity: '1' }
      ],
      options: {
        duration: 230
      }
    )
  end

  # Change the animation for even numbered dialogs
  document.query_selector_all(".masonry-item:nth-child(even) sl-dialog").each do |dialog|
    set_animation(dialog, 'dialog.show',
      keyframes: [
        { transform: 'rotate(5deg) scale(0.6)', opacity: '0' },
        { transform: 'rotate(0deg) scale(1)', opacity: '1' }
      ],
      options: {
        duration: 230
      }
    )
  end
end
