import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["header", "messageForm"]
  static values = {
    url: String
  }

  connect() {
    if (window.isNativeApp) {
      this.headerHeight = window.statusBarHeight;
      this.setHeaderPadding();
      this.setMessageFormPadding();
      this.listenForNewExpoToken(); // needed to send push notifications to native mobile
    }
  }

  listenForNewExpoToken() {
    const reactNativeController = this; // refers to this stimulus controller (to enable use in callback)
    window.addEventListener('setExpoPushToken', (e) => {
      if (e.expoPushToken) {
        Rails.ajax({
          type: "patch",
          url: reactNativeController.urlValue,
          data: {user: {expo_token: e.expoPushToken}}
        })
      }
    })
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
