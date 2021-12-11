const Ruby2JS = require('@ruby2js/ruby2js')
const convert = require('convert-source-map')

const ruby2JSPlugin = (options = {}) => ({
  name: 'ruby2js',
  setup(build) {
    const fs = require('fs').promises

    if (!options.buildFilter) options.buildFilter = /\.js\.rb$/

    build.onLoad({ filter: options.buildFilter }, async (args) => {
      const code = await fs.readFile(args.path, 'utf8')
      js = Ruby2JS.convert(code, { ...options, file: args.path })
      const outputJs = js.toString() + convert.fromObject(js.sourcemap).toComment()
      return {
        contents: outputJs,
        loader: 'js'
      }
    })
  },
})

module.exports = ruby2JSPlugin