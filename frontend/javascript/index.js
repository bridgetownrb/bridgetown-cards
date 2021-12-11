import '@shoelace-style/shoelace/dist/themes/light.css'
import '@shoelace-style/shoelace/dist/components/alert/alert.js'
import '@shoelace-style/shoelace/dist/components/button/button.js'
import '@shoelace-style/shoelace/dist/components/card/card.js'
import '@shoelace-style/shoelace/dist/components/dialog/dialog.js'
import '@shoelace-style/shoelace/dist/components/form/form.js'
import '@shoelace-style/shoelace/dist/components/icon/icon.js'
import '@shoelace-style/shoelace/dist/components/input/input.js'
import '@shoelace-style/shoelace/dist/components/tag/tag.js'
import { registerIconLibrary } from '@shoelace-style/shoelace/dist/utilities/icon-library.js'

import * as Turbo from "@hotwired/turbo"

import smoothscroll from 'smoothscroll-polyfill'
// kick off the polyfill!
smoothscroll.polyfill()

import "index.css"

registerIconLibrary('remixicon', {
  resolver: name => {
    const match = name.match(/^(.*?)\/(.*?)(-(fill))?$/);
    match[1] = match[1].charAt(0).toUpperCase() + match[1].slice(1);
    return `https://cdn.jsdelivr.net/npm/remixicon@2.5.0/icons/${match[1]}/${match[2]}${match[3] || '-line'}.svg`;
  },
  mutator: svg => svg.setAttribute('fill', 'currentColor')
});

window.addEventListener("DOMContentLoaded", () => {
  const dialog = document.querySelector("sl-dialog#donation")

  if (dialog) {
    if ((window.innerWidth < 500 && window.innerHeight < 740) || window.innerHeight < 700) {
      dialog.classList.add("scrollable")
    }

    const closeButton = dialog.querySelector("sl-button[slot='footer']")

    closeButton.addEventListener("click", () => dialog.hide())

    document.querySelectorAll("sl-button[data-open-donate]").forEach(item => {
      item.addEventListener("click", () => {
        dialog.show()
        setTimeout(() => {
          dialog.shadowRoot.querySelector("[part='body']").scrollTo({top: 40, behavior: "smooth"})
          setTimeout(() => {
            dialog.shadowRoot.querySelector("[part='body']").scrollTo({top: 0, behavior: "smooth"})
          }, 500)
        }, 400)
      })
    })
  }
})

/**************
 * Masonry code tweaked from https://w3bits.com/css-grid-masonry/ generator
 */

const resizeMasonryItem = (item) => {
  /* Get the grid object, its row-gap, and the size of its implicit rows */
  const grid = document.getElementsByClassName('masonry')[0]
  if (grid) {
    const rowGap = parseInt(window.getComputedStyle(grid).getPropertyValue('grid-row-gap')),
          rowHeight = parseInt(window.getComputedStyle(grid).getPropertyValue('grid-auto-rows'))

// If you need images:       gridImagesAsContent = item.querySelector('img.masonry-content');

    /*
     * Spanning for any brick = S
     * Grid's row-gap = G
     * Size of grid's implicitly create row-track = R
     * Height of item content = H
     * Net height of the item = H1 = H + G
     * Net height of the implicit row-track = T = G + R
     * S = H1 / T
     */
    const rowSpan = Math.ceil((item.querySelector('.masonry-content').getBoundingClientRect().height + rowGap) / (rowHeight + rowGap))

    /* Set the spanning as calculated above (S) */
    item.style.gridRowEnd = 'span ' + rowSpan

/*    if (gridImagesAsContent) {
      item.querySelector('img.masonry-content').style.height = item.getBoundingClientRect().height + "px"
    } */
  }
}

const resizeAllMasonryItems = () => {
  setTimeout(() => {
    // Get all item class objects in one list
    const allItems = document.querySelectorAll('.masonry-item')

    /*
    * Loop through the above list and execute the spanning function to
    * each list-item (i.e. each masonry item)
    */
    allItems.forEach(item => resizeMasonryItem(item))
  })
}

/* Resize all the grid items on the load and resize events */
const masonryEvents = ['turbo:load', 'resize']
masonryEvents.forEach(event => {
  window.addEventListener(event, resizeAllMasonryItems)
})

window.addEventListener("turbo:load", () => {
  document.querySelectorAll("sl-card sl-button").forEach(button => {
    button.addEventListener("click", (e) => {
      e.currentTarget.closest('.masonry-item').querySelector('sl-dialog').show()

      if (e.target.localName != "a") {
        const anchor = e.currentTarget.querySelector("a")
        if (anchor) anchor.click()
      }
    })
  })
})
