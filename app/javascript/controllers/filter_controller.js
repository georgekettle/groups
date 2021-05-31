import { Controller } from "stimulus"
import Shuffle from 'shufflejs'

export default class extends Controller {
  static targets = ["search", "container"]

  initialize() {
    console.log("filter!");
    this.initShuffle();
    this.hasSearchTarget && this.initSearch();
  }

  initShuffle() {
    this.shuffle = new Shuffle(this.containerTarget, {
      itemSelector: '.filter-item',
      sizer: '.filter-sizer-element',
    });
  }

  initSearch() {
    this.searchTarget.addEventListener('keyup', (e) => {
      let query = e.currentTarget.value.toLowerCase();
      this.applyFilter(query);
    })
  }

  applyFilter(query) {
    this.shuffle.filter(function (element, shuffle) {
      var elementText = element.dataset.filterText.toLowerCase();

      return elementText.indexOf(query) !== -1;
    });
  }
}
