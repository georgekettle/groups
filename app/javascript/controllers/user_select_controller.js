import { Controller } from "stimulus"
import * as Choices from "choices.js"
import Rails from "@rails/ujs"
import algoliasearch from "algoliasearch"

export default class extends Controller {
  static values = {
    algoliaId: String,
    algoliaSearchKey: String,
    indexModel: String,
    searchOptions: Object
  }

  initialize() {
    this.isProfile = ['Profile_production','Profile_development'].includes(this.indexModelValue)
    this.choices = this.initChoices()
    this.choices.clearChoices()
    this.initSearch()
  }

  initChoices() {
    const userSelectController = this;
    // Pass single element
    const element = this.element;

    // Passing options (with default options)
    const choices = new Choices(element, {
      silent: false,
      items: [],
      choices: [],
      removeItems: true,
      removeItemButton: true,
      searchResultLimit: 10,
      duplicateItemsAllowed: false,
      placeholder: true,
      placeholderValue: "Search a user",
      searchPlaceholderValue: "Search a user",
      renderSelectedChoices: 'auto',
      loadingText: 'Loading...',
      noResultsText: 'No results found',
      noChoicesText: 'No choices to choose from',
      itemSelectText: 'Press to select',
      addItemText: (value) => {
        return `Press Enter to add <b>"${value}"</b>`;
      },
      maxItemText: (maxItemCount) => {
        return `Only ${maxItemCount} values can be added`;
      },
      callbackOnCreateTemplates: function(template) {
        return {
          item: (classNames, data) => {
            return template(`
              <div class="${classNames.item} ${
              data.highlighted
                ? classNames.highlightedState
                : classNames.itemSelectable
            } ${
              data.placeholder ? classNames.placeholder : ''
            }" data-item data-id="${data.id}" data-value="${data.value}" ${
              data.active ? 'aria-selected="true"' : ''
            } ${data.disabled ? 'aria-disabled="true"' : ''} data-deletable>
                <span>${userSelectController.avatarTemplate(data)}</span>
                ${data.label}
                <button type="button" class="choices__button" aria-label="Remove item: '${data.id}'" data-button="">Remove item</button>
              </div>
            `);
          },
          choice: (classNames, data) => {
            return template(`
              <div class="${classNames.item} ${classNames.itemChoice} ${
              data.disabled ? classNames.itemDisabled : classNames.itemSelectable
            }" data-select-text="${this.config.itemSelectText}" data-choice ${
              data.disabled
                ? 'data-choice-disabled aria-disabled="true"'
                : 'data-choice-selectable'
            } data-id="${data.id}" data-value="${data.value}" ${
              data.groupId > 0 ? 'role="treeitem"' : 'role="option"'
            }>
                <span>${userSelectController.avatarTemplate(data)}</span> ${data.label}
              </div>
            `);
          },
        };
      },
    });

    return choices;
  }

  avatarTemplate(data) {
    if (data.customProperties && data.customProperties.avatar) {
      // return `<img src="${data.customProperties.avatar}" alt="${data.label}" class="inline-block h-6 w-6 rounded-full ring-2 ring-white">`
      return data.customProperties.avatar
    }
    // console.log(`<img src="${data}" alt="${data}">`)
    return ``
  }

  handleSuccess(data) {
    const results = data.hits;
    const newChoices = results.map((result) => {
      console.log(result);
      let profile = this.isProfile ? result : result.profile;
      return({
        value: profile.objectID,
        label: profile.full_name,
        customProperties: {
          avatar: profile.avatar_template
        },
      })
    })

    this.choices.clearChoices()
    this.choices.setChoices(
      newChoices,
      'value',
      'label',
      false,
    );
  }

  handleError(data) {
    console.log(data);
  }

  search(query, index) {
    const userSelectController = this;

    index.search(query, this.searchOptionsValue)
      .then(function searchDone(content) {
        userSelectController.handleSuccess(content);
      })
      .catch(function searchFailure(err) {
        userSelectController.handleError(err);
      });
  }

  initSearch() {
    var client = algoliasearch(this.algoliaIdValue, this.algoliaSearchKeyValue);
    var index = client.initIndex(this.indexModelValue);

    // initial search to populate results from algolia
    this.search('', index)

    const userSelectController = this;
    this.element.addEventListener('search', (e) => {
      const query = e.detail.value;
      userSelectController.search(query, index)
    }, false)
  }
}
