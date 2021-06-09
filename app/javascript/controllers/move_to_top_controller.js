import { Controller } from "stimulus"

export default class extends Controller {
  initialize() {
    this.parent = this.element.parentElement;
    this.moveTo(this.positionValue);
  }

  moveTo(position) {
    console.log(`moving item to: ${position}`)
    this.parent.insertAdjacentElement('afterbegin', this.element);
  }
}
