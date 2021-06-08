import { Controller } from "stimulus"
import Shuffle from 'shufflejs'

export default class extends Controller {
  static targets = ["search", "container"]

  initialize() {
    this.hasSearchTarget && this.initSearch();
  }

  initSearch() {
    this.searchTarget.addEventListener('keyup', (e) => {
      let query = e.currentTarget.value.toLowerCase();
      this.applyFilter(query);
    })
  }

  applyFilter(query) {
    // const selectFilterClasses = this.inclusiveFiltersValue.length ? this.inclusiveFiltersValue.map(inclusiveFilter => `:scope > ${filterClasses}${inclusiveFilter}`).join(',') : filterClasses;
    // const deselectFilterClasses = this.inclusiveFiltersValue.length ? this.inclusiveFiltersValue.map(inclusiveFilter => `:scope > div:not(${filterClasses}${inclusiveFilter})`).join(',') : `:scope > div:not(${filterClasses})`;
    const childDivs = Array.from(this.containerTarget.children).filter(elem => elem.tagName === 'DIV')
    childDivs.forEach((elem) => {
      var elemText = elem.dataset.filterText;
      if (elemText) {
        this.isQueryMatch(elemText, query) && this.showElement(elem)
        !this.isQueryMatch(elemText, query) && this.hideElement(elem)
      }
    })
  }

  isQueryMatch(text, query) {
    return text.toLowerCase().indexOf(query) !== -1
  }


  showElement(elem) {
    if (elem.classList.contains('fadeOutShrink')) {
      elem.classList.add('animated','fadeInExpand');
      elem.classList.remove('fadeOutShrink');
    }
  }

  hideElement(elem) {
    elem.classList.add('animated','fadeOutShrink');
    elem.classList.remove('fadeInExpand');
  }


  // applyFilter() {
  //   const filterClasses = this.filtersValue.length ? this.filtersValue.join('') : '*';
  //   const selectFilterClasses = this.inclusiveFiltersValue.length ? this.inclusiveFiltersValue.map(inclusiveFilter => `:scope > ${filterClasses}${inclusiveFilter}`).join(',') : filterClasses;
  //   const deselectFilterClasses = this.inclusiveFiltersValue.length ? this.inclusiveFiltersValue.map(inclusiveFilter => `:scope > div:not(${filterClasses}${inclusiveFilter})`).join(',') : `:scope > div:not(${filterClasses})`;

  //   if (deselectFilterClasses.length) {
  //     let deselected = this.parentTarget.querySelectorAll(deselectFilterClasses);
  //     this.hideElements(deselected);
  //   }

  //   if (selectFilterClasses.length) {
  //     let selected = this.parentTarget.querySelectorAll(selectFilterClasses);
  //     this.showElements(selected);
  //   }
  // }
}
