import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["header", "messageForm"]

  connect() {
    if (window.isNativeApp) {
      this.headerHeight = window.statusBarHeight;
      this.setHeaderPadding();
      this.setMessageFormPadding()
    }
  }

  setHeaderPadding() {
    if (this.hasHeaderTarget && this.headerHeight) {
      this.headerTarget.style.paddingTop = `${this.headerHeight}px`;
      // window.ReactNativeWebView.postMessage(`headerHeight: ${this.headerHeight}`)
    }
  }

  setMessageFormPadding() {
    if (this.hasMessageFormTarget && this.headerHeight) {
      this.messageFormTarget.style.paddingBottom = `${this.headerHeight}px`;
      // window.ReactNativeWebView.postMessage(`headerHeight: ${this.headerHeight}`)
    }
  }
}
