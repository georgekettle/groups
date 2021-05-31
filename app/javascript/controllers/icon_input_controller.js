import { Controller } from "stimulus"

export default class extends Controller {
  initialize() {
    console.log("icon input!");
    this.inputTarget = this.element.querySelector('input');
    this.initInputContainer();
    this.initInput()
  }

  initInputContainer() {
    this.element.addEventListener('click', (e) => {
      this.inputTarget.focus();
      this.element.classList.add('active');
    })
  }

  initInput() {
    this.inputTarget.addEventListener('blur', (e) => {
      this.element.classList.remove('active');
    })
  }
}
