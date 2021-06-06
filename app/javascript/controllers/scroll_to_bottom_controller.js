import { Controller } from "stimulus"
import anime from "animejs"

export default class extends Controller {
  initialize() {
    if (this.element.hasChildNodes()) {
      this.scrollToBottom()
      this.initAnimeStagger()
    }
  }

  initAnimeStagger() {
    document.addEventListener('turbo:load', () => {
      anime({
        targets: this.element.children,
        translateY: [5, 0],
        opacity: [0, 1],
        easing: 'easeInOutQuad',
        delay: anime.stagger(10),
        easing: 'spring(1, 80, 10, 0)'
      });
    })
  }

  scrollToBottom() {
    this.element.scrollTo(0, this.element.lastElementChild.offsetTop)
  }
}
