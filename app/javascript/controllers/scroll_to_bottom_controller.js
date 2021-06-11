import { Controller } from "stimulus"
import anime from "animejs"

export default class extends Controller {
  initialize() {
    if (this.element.hasChildNodes()) {
      this.pageAnchor() ? this.scrollToAnchor(this.pageAnchor()) : this.scrollToBottom()
    }
  }

  scrollToBottom() {
    this.element.scrollTo(0, this.element.lastElementChild.offsetTop)
  }

  scrollToAnchor(anchor) {
    const anchorElem = document.getElementById(anchor)
    this.element.scrollTo(0, anchorElem.offsetTop)

    document.addEventListener('turbo:load', () => {
      this.highlightAnchor(anchorElem);
    })
  }

  highlightAnchor(anchorElem) {
    anchorElem.classList.add('animated', 'animated-duration-1000', 'highlight')
  }

  pageAnchor() {
    var stripped_url = document.location.toString().split("#")
    if (stripped_url.length > 1) return stripped_url[1]
    if (stripped_url.length <= 1) return false
  }
}
