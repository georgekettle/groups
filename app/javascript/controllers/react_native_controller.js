import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["header", "messageForm"]
  static values = {
    url: String,
    askToAcceptNotifications: Boolean
  }

  connect() {
    if (window.isNativeApp) {
      this.headerHeight = window.statusBarHeight;
      this.setHeaderPadding();
      this.setMessageFormPadding();
      if (this.urlValue) {
        // will have a urlValue if user_signed_in?
        if (this.askToAcceptNotificationsValue == true) {
          this.askToAcceptNotifications()
          this.listenForNewExpoToken(); // needed to send push notifications to native mobile
        }
      }
    }
  }

  askToAcceptNotifications() {
    // send trigger to react native to show accept notifications page
    window.ReactNativeWebView.postMessage(`{"displayAllowNotifications": true}`)
  }

  listenForNewExpoToken() {
    const reactNativeController = this; // refers to this stimulus controller (to enable use in callback)
    window.addEventListener('setExpoPushToken', (e) => {
      window.alert('setExpoPushToken event triggered (WOOHOO 🤓)');
      if (e.detail) {
        let expoToken = (e.detail === '') ? null : e.detail;
        window.alert(`this is the expo token: ${e.detail}`);
        Rails.ajax({
          type: "patch",
          url: reactNativeController.urlValue,
          data: {"user": {"expo_token": e.detail, "ask_to_accept_notifications": false}}
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
