import { Controller } from "stimulus"

const defineLoader = (classes) => {
  return(`<svg class="stroke-current animate-spin mx-auto ${classes}" width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
      <g id="Page-1" stroke-width="1" fill="none" fill-rule="evenodd">
          <g id="Interface,-Essential/Loading,-Waiting" transform="translate(-2.000000, -2.000000)">
              <g id="Group" transform="translate(-0.000000, -0.000000)">
                  <g id="Path">
                      <polygon points="0 0 24.0000001 0 24.0000001 24.0000001 0 24.0000001"></polygon>
                      <path d="M12.0000001,17.6200001 L12.0000001,21.0000001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      <path d="M8.02000003,15.9800001 L5.64000002,18.3600001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      <path d="M6.38000003,12.0000001 L3.00000001,12.0000001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      <path d="M5.64000002,5.64000002 L8.02000003,8.02000003" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      <path d="M12.0000001,6.00000003 L12.0000001,3.00000001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      <path d="M16.7700001,7.23000003 L18.3600001,5.64000002" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      <path d="M21.0000001,12.0000001 L19.5000001,12.0000001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      <path d="M18.3600001,18.3600001 L17.8300001,17.8300001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                  </g>
              </g>
          </g>
      </g>
  </svg>`);
}

export default class extends Controller {
  static values = { classes: String }

  connect() {
    delete this.element.dataset.disableWith;
    if (this.classesValue === '') {
      this.classesValue = 'text-white w-4 h-4'
    };
    this.loader = defineLoader(this.classesValue);
  }

  showLoader(e) {
    let positionInfo = this.element.getBoundingClientRect();
    let width = positionInfo.width;
    this.element.style.width = `${parseInt(width + 1, 10)}px`;
    this.element.innerHTML = this.loader;
    return true
  }
}
