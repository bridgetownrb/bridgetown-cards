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
