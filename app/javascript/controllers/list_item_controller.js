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

  moveTo(position) {
    console.log("THIS NEEDS TO BE FIXED (CHANNEL LIST ITEM)")
    console.log(`moving item to: ${position}`)
    this.parent.insertAdjacentElement(position, this.element);
  }
}
