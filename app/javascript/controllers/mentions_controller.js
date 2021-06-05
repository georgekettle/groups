import { Controller } from "stimulus"
import Tribute from 'tributejs'
import Trix from 'trix'
import algoliasearch from "algoliasearch"

export default class extends Controller {
  static targets = ["field"]
  static values = {
    algoliaId: String,
    algoliaSearchKey: String,
    indexModel: String, // this will be Profile or Profile_development
  }

  initialize() {
    this.editor = this.fieldTarget.editor;
    this.algolia = this.initSearch();
    this.initializeTribute();
  }

  initializeTribute() {
    this.tribute = new Tribute({
      allowSpaces: true,
      lookup: 'full_name',
      values: this.fetchProfiles.bind(this),
    })
    this.tribute.attach(this.fieldTarget)
    this.tribute.range.pasteHtml = this._pasteHtml.bind(this)
    this.fieldTarget.addEventListener("tribute-replaced", this.replaced)
  }

  disconnect() {
    this.tribute.detach(this.fieldTarget)
  }

  fetchProfiles(text, callback) {
    this.algolia.search(text, { "hitsPerPage": 10, "page": 0 })
      .then(content => callback(content.hits))
      .catch(error => callback([]))
  }

  replaced(e) {
    let profile = e.detail.item.original
    let attachment = new Trix.Attachment({
      sgid: profile.sgid,
      content: profile.mention_template
    })
    this.editor.insertAttachment(attachment)
    this.editor.insertString(" ")
  }

  _pasteHtml(html, startPos, endPos) {
    let position = this.editor.getPosition()
    this.editor.setSelectedRange([position - (endPos - startPos), position])
    this.editor.deleteInDirection("backward")
  }

  initSearch() {
    var client = algoliasearch(this.algoliaIdValue, this.algoliaSearchKeyValue);
    var index = client.initIndex(this.indexModelValue);
    // console.log(index);
    return index
  }
}
