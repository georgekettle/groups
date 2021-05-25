import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    position: String,
  }

  initialize() {
    this.parent = this.element.parentElement;
    if (this.positionValue) {
      console.log(this.element);
      this.moveTo(this.positionValue);
    }
  }

  disconnect() {
    // console.log(this.element)
  }

  moveTo(position) {
    console.log(`moving item to: ${position}`)
    // console.log(this.element);
    this.parent.insertAdjacentElement(position, this.element);
  }
}
