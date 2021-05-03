import { Controller } from "stimulus"
import * as Choices from "choices.js"
import Rails from "@rails/ujs";

export default class extends Controller {
  static values = {
    url: String
  }

  initialize() {
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
    const newChoices = data.map((profile) => {
      return({
        value: profile.id,
        label: profile.full_name,
        customProperties: {
          description: 'Custom description about Option 2',
          avatar: profile.avatar_small
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
    const userSelectController = this;
    this.element.addEventListener('search', (e) => {
      const query = e.detail.value;
      Rails.ajax({
        type: "get",
        url: `${this.urlValue}.json`,
        data: `q=${query}`,
        success: function (data) {
          userSelectController.handleSuccess(data);
        },
        error: function (data) {
          userSelectController.handleError(data);
        },
      })

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
