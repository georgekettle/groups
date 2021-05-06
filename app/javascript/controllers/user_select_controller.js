import { Controller } from "stimulus"
import * as Choices from "choices.js"
import Rails from "@rails/ujs";
import algoliasearch from "algoliasearch";

export default class extends Controller {
  static values = {
    url: String,
    algoliaId: String,
    algoliaSearchKey: String,
    indexModel: String,
    searchOptions: Object
  }

  initialize() {
    this.isProfile = ['Profile','Profile_development'].includes(this.indexModelValue)
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
    console.log("handleSuccess");
    console.log(data);
    const newChoices = data.map((result) => {
      console.log(result);
      let profile = this.isProfile ? result : result.profile;
      console.log(this.indexModelValue)
      console.log('this.isProfile:', this.isProfile)
      console.log(profile);
      return({
        value: profile.objectID,
        label: profile.full_name,
        customProperties: {
          // avatar: profile.avatar_small
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

  initSearch() {
    var client = algoliasearch(this.algoliaIdValue, this.algoliaSearchKeyValue);
    var index = client.initIndex(this.indexModelValue);

    const userSelectController = this;
    this.element.addEventListener('search', (e) => {
      const query = e.detail.value;
      index.search(query, userSelectController.searchOptionsValue)
      .then(function searchDone(content) {
        console.log(content);
        userSelectController.handleSuccess(content.hits);
      })
      .catch(function searchFailure(err) {
        console.error(err);
        userSelectController.handleError(err);
      });
      // Rails.ajax({
      //   type: "get",
      //   url: `${this.urlValue}.json`,
      //   data: `q=${query}`,
      //   success: function (data) {
      //     userSelectController.handleSuccess(data);
      //   },
      //   error: function (data) {
      //     userSelectController.handleError(data);
      //   },
      // })

      // userSelectController.choices.setChoices(async () => {
      //   try {
      //     const items = await fetch('/profiles');
      //     return items.json();
      //   } catch (err) {
      //     console.error(err);
      //   }
      // });
    }, false)
  }
}


// const example = new Choices(element);

// // Passing a function that returns Promise of choices
// example.setChoices(async () => {
//   try {
//     const items = await fetch('/items');
//     return items.json();
//   } catch (err) {
//     console.error(err);
//   }
// });
