import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["button"]

  initialize() {
    this.buttonContentValue = this.buttonTarget.innerHTML;
  }

  reset() {
    this.element.reset();
    this.buttonTarget.disabled = false;
    this.buttonTarget.innerHTML = this.buttonContentValue;
  }
}
