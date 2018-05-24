this.defineCustomElement = function(elementName) {
  const template = document.currentScript.ownerDocument
    .getElementById(`${elementName}-template`)
    .content

  const customElementClass = class extends HTMLElement {
    constructor() {
      super()
      this.attachShadow({mode: 'open'})
        .appendChild(template.cloneNode(true))
    }
  }

  customElements.define(elementName, customElementClass)

  return customElementClass
}
