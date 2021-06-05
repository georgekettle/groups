import { Controller } from "stimulus"
import Trix from 'trix'

export default class extends Controller {
  static targets = ["editor", "submit", "toolbar", "bold", "italic", "strikethrough", "href"]

  initialize() {
    // this.trix = this.editorTarget.editor; // don't need this yet (but will come in handy)
    this.initOpenOnFocus();
    this.initCloseOnBlur();
    this.moveToolbar();
    this.initButtons();
    // this.initSubmitOnEnter(); // this doesn't work with mentions (please fix... would be great feature)
  }

  // initSubmitOnEnter() {
  //   this.editorTarget.addEventListener("keydown", event => {
  //     if (event.key == "Enter") {
  //       event.preventDefault()
  //       this.submitTarget.click()
  //     }
  //   })
  // }

  focus() {
    this.editorTarget.focus()
  }

  initOpenOnFocus() {
    this.editorTarget.addEventListener('trix-focus', (e) => {
      this.element.classList.add('message-form-active');
    })
  }

  initCloseOnBlur() {
    this.editorTarget.addEventListener('trix-blur', (e) => {
      if (e.currentTarget.value === "") {
        this.element.classList.remove('message-form-active');
      }
    })
  }

  moveToolbar() {
    this.editorTarget.addEventListener('trix-initialize', (e) => {
      this.toolbar = e.currentTarget.previousSibling;
      this.toolbar = document.querySelector('trix-toolbar');
      this.toolbarTarget.insertAdjacentElement('afterbegin', this.toolbar);
    })
  }

  initButtons() {
    this.editorTarget.addEventListener('trix-initialize', (e) => {
      this.initBold();
      this.initItalic();
      this.initStrikethrough();
      this.initHref();
    })
  }

  initBold() {
    let trixBoldButton = this.toolbar.querySelector('.trix-button--icon-bold');
    trixBoldButton.innerHTML = '';
    trixBoldButton.insertAdjacentElement('afterbegin', this.boldTarget);
  }

  initItalic() {
    let trixItalicButton = this.toolbar.querySelector('.trix-button--icon-italic');
    trixItalicButton.innerHTML = '';
    trixItalicButton.insertAdjacentElement('afterbegin', this.italicTarget);
  }

  initStrikethrough() {
    let trixStrikethroughButton = this.toolbar.querySelector('.trix-button--icon-strike');
    trixStrikethroughButton.innerHTML = '';
    trixStrikethroughButton.insertAdjacentElement('afterbegin', this.strikethroughTarget);
  }

  initHref() {
    let trixHrefButton = this.toolbar.querySelector('.trix-button--icon-link');
    trixHrefButton.innerHTML = '';
    trixHrefButton.insertAdjacentElement('afterbegin', this.hrefTarget);
  }
}
