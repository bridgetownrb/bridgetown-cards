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

register_icon_library('remixicon', 
  resolver: -> name do
    match = name.match(/^(.*?)\/(.*?)(-(fill))?$/)
    match[1] = match[1].char_at(0).upcase() + match[1].slice(1)
    "https://cdn.jsdelivr.net/npm/remixicon@2.5.0/icons/#{match[1]}/#{match[2]}#{match[3] || '-line'}.svg";
  end,
  mutator: -> svg { svg.set_attribute('fill', 'currentColor') }
)

# **************
# * Masonry code tweaked from https://w3bits.com/css-grid-masonry/ generator
# *

def resize_masonry_item(item)
  # Get the grid object, its row-gap, and the size of its implicit rows
  grid = document.get_elements_by_class_name('masonry')[0]

  if grid
    row_gap = window.get_computed_style(grid).get_property_value('grid-row-gap').to_i
    row_height = window.get_computed_style(grid).get_property_value('grid-auto-rows').to_i

    # If you need images:
    # gridImagesAsContent = item.querySelector('img.masonry-content')

    # /*
    #  * Spanning for any brick = S
    #  * Grid's row-gap = G
    #  * Size of grid's implicitly create row-track = R
    #  * Height of item content = H
    #  * Net height of the item = H1 = H + G
    #  * Net height of the implicit row-track = T = G + R
    #  * S = H1 / T
    #  */
    row_span = (
      (item.query_selector('.masonry-content').get_bounding_client_rect().height + row_gap) / (row_height + row_gap)
    ).ceil

    # Set the spanning as calculated above (S)
    item.style.grid_row_end = "span #{row_span}"

    # if gridImagesAsContent
    #   item.querySelector('img.masonry-content').style.height = item.getBoundingClientRect().height + "px"
    # end
  end
end

def resize_all_masonry_items()
  set_timeout do
    # Get all item class objects in one list
    all_items = document.query_selector_all('.masonry-item')

    # /*
    # * Loop through the above list and execute the spanning function to
    # * each list-item (i.e. each masonry item)
    # */
    all_items.each { |item| resize_masonry_item(item) }
  end
end

# Resize all the grid items on the load and resize events
['turbo:load', 'resize'].each do |event|
  window.add_event_listener event, resize_all_masonry_items
end

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
