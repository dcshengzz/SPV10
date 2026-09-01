var webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');

var appConfig = {
    name: "app",
    entry:  "./app.js",
	mode: 'production',
	cache: true,
	
  output: {
    filename: "app.js",
    path: __dirname + "/build",
  },

  module: {
    rules: [
      {
        test: /.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
		options: {
			presets: ['@babel/preset-env', '@babel/preset-react'],
			plugins: [
				"@babel/plugin-transform-modules-commonjs",
				
				// Stage 2
				["@babel/plugin-proposal-decorators", { "legacy": true }],
				"@babel/plugin-proposal-function-sent",
				"@babel/plugin-proposal-export-namespace-from",
				"@babel/plugin-proposal-numeric-separator",
				"@babel/plugin-proposal-throw-expressions",
				
				// Stage 3
				"@babel/plugin-syntax-dynamic-import",
				"@babel/plugin-syntax-import-meta",
				["@babel/plugin-transform-class-properties", { "loose": true }],
				"@babel/plugin-transform-json-strings",
				
				//Silence Warning
				["@babel/plugin-transform-private-property-in-object", { "loose": true }],
				["@babel/plugin-transform-private-methods", { "loose": true }]
			]
		}
      },
      {
        test: /\.scss$/,
        use: ['style-loader', 'css-loader','sass-loader']
      }
    ]
  },
  resolve: {
    extensions: ['*', '.js', '.json', '.jsx', '.css', '.scss']
  },
  plugins:[
  ]
};

var libConfig = {
    name: "app",
    entry:  "./index.js",
	mode: 'production',
	cache: true,
	
  output: {
    filename: "swz-survey-admin.js",
    path: __dirname + "/build",
    library: 'swz-survey-admin',
    libraryTarget: 'umd'
  },

  module: {
    rules: [
      {
        test: /.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
		options: {
			presets: ['@babel/preset-env', '@babel/preset-react'],
			plugins: [
				"@babel/plugin-transform-modules-commonjs",
				
				// Stage 2
				["@babel/plugin-proposal-decorators", { "legacy": true }],
				"@babel/plugin-proposal-function-sent",
				"@babel/plugin-proposal-export-namespace-from",
				"@babel/plugin-proposal-numeric-separator",
				"@babel/plugin-proposal-throw-expressions",
				
				// Stage 3
				"@babel/plugin-syntax-dynamic-import",
				"@babel/plugin-syntax-import-meta",
				["@babel/plugin-transform-class-properties", { "loose": true }],
				"@babel/plugin-transform-json-strings",
				
				//Silence Warning
				["@babel/plugin-transform-private-property-in-object", { "loose": true }],
				["@babel/plugin-transform-private-methods", { "loose": true }]
			  ]
		}
      },
      {
        test: /\.scss$/,
        use: ['style-loader', 'css-loader','sass-loader']
      }
    ]
  },
  resolve: {
    extensions: ['*', '.js', '.json', '.jsx', '.css', '.scss']
  },
  plugins:[
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    }),
    new webpack.optimize.AggressiveMergingPlugin()
  ],
  optimization: {
	chunkIds:'natural',
	minimize: true,
    minimizer: [new TerserPlugin({
	  include: /\.min\.js$/
	})],
  },
  externals: [
    "json5",
    "react",
    "react-data-grid",
    "react-dom",
    "semantic-ui-react",
    "webpack",
	"webpack-cli",
    "webpack-dev-server",
	"terser-webpack-plugin",
    "@babel/core",
    "@babel/eslint-parser",
	"@babel/plugin-proposal-decorators",
	"@babel/plugin-proposal-export-namespace-from",
    "@babel/plugin-proposal-function-sent",
    "@babel/plugin-proposal-numeric-separator",
    "@babel/plugin-proposal-throw-expressions",
    "@babel/plugin-syntax-dynamic-import",
    "@babel/plugin-syntax-import-meta",
    "@babel/plugin-transform-class-properties",
    "@babel/plugin-transform-json-strings",
    "@babel/plugin-transform-member-expression-literals",
	"@babel/plugin-transform-modules-commonjs",
    "@babel/plugin-transform-property-literals",
    "@babel/plugin-transform-react-jsx",
    "@babel/preset-env",
    "@babel/preset-react",
    "babel-loader",
    "babel-plugin-typecheck"
  ]
};

module.exports = [appConfig, libConfig];