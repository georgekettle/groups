import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    connectAnimations: String,
    disconnectAnimations: String,
    duration: String,
  }

  connect() {
    this.element.style.animationDuration = this.durationValue || '0.5s';
    this.connectAnimationsValue = this.connectAnimationsValue || 'fade-in';
    this.disconnectAnimationsValue = this.disconnectAnimationsValue || 'fade-in';
    this.element.classList.add('animate', this.connectAnimationsValue);
  }

  disconnect() {
    this.element.classList.add('animate', 'reverse', this.connectAnimationsValue);
  }

  // remove() {
  //   // trigger disconnect animation
  //   // remove element from screen
  // }
}
