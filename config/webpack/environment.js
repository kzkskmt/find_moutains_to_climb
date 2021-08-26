const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
)

environment.config.merge({
  performance: {
    maxAssetSize: 1000 * 1024, //entrypointサイズリミットを1000kibまでに設定
    maxEntrypointSize: 1000 * 1024, //assetのファイルサイズリミットを1000kibまでに設定
  }
})

module.exports = environment
