const webComponentName = require('path').basename(__dirname)
const selectorPrefix = `.${webComponentName}_`

module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-css-variables'),
    // require('postcss-filter-rules')({
    //   filter: selector => selector.startsWith(selectorPrefix),
    // })
  ],
}
