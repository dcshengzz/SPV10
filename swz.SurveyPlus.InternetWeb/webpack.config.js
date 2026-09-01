var webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');

var resphelp = {
	mode: 'production',
	cache: true,
    entry: ["./wwwroot/js/app/resphelp.jsx"],
    output: {
        filename: "./../wwwroot/js/resphelp.js"
    },
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                loader: "babel-loader",
                exclude: /node_modules/,
                options: {
                    presets: [['@babel/preset-env', {"useBuiltIns": "entry", "corejs": "3.33", "targets": "> 0.25%, not dead"}], '@babel/preset-react'],
					plugins: [
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
            }
        ]
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env': {
                'NODE_ENV': JSON.stringify('production')
                //'NODE_ENV': JSON.stringify('development')
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
};

var resplogin = {
	mode: 'production',
	cache: true,
    entry: ["./wwwroot/js/app/resplogin.jsx"],
    output: {
        filename: "./../wwwroot/js/resplogin.js"
    },
    //devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                loader: "babel-loader",
                exclude: /node_modules/,
                options: {
                    presets: [['@babel/preset-env', {"useBuiltIns": "entry", "corejs": "3.33", "targets": "> 0.25%, not dead"}], '@babel/preset-react'],
					plugins: [
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
            }
        ]
    },
    plugins:[
        new webpack.DefinePlugin({
            'process.env': {
		        'NODE_ENV': JSON.stringify('production')
		        //'NODE_ENV': JSON.stringify('development')
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
};


var app = {
	mode: 'production',
	cache: true,
    entry: ["./wwwroot/js/app/app.jsx"],
    //devtool: 'source-map',
    output: {
        filename: "./../wwwroot/js/app.js"
    },
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                loader: "babel-loader",
                exclude: /node_modules/,
                options: {
                    presets: [['@babel/preset-env', {"useBuiltIns": "entry", "corejs": "3.33", "targets": "> 0.25%, not dead"}], '@babel/preset-react'],
					plugins: [
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
            }
        ]
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
};

var respchangepassword = {
	mode: 'production',
	cache: true,
    entry: ["./wwwroot/js/app/respchangepassword.jsx"],
    output: {
        filename: "./../wwwroot/js/respchangepassword.js"
    },
    //devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                loader: "babel-loader",
                exclude: /node_modules/,
                options: {
                    presets: [['@babel/preset-env', {"useBuiltIns": "entry", "corejs": "3.33", "targets": "> 0.25%, not dead"}], '@babel/preset-react'],
					plugins: [
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
            }
        ]
    },
    plugins:[
        new webpack.DefinePlugin({
            'process.env': {
		        'NODE_ENV': JSON.stringify('production')
		        //'NODE_ENV': JSON.stringify('development')
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
};

var inviteschangepassword = {
	mode: 'production',
	cache: true,
    entry: ["./wwwroot/js/app/inviteschangepassword.jsx"],
    output: {
        filename: "./../wwwroot/js/inviteschangepassword.js"
    },
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                loader: "babel-loader",
                exclude: /node_modules/,
                options: {
                    presets: [
						['@babel/preset-env', {"useBuiltIns": "entry", "corejs": "3.33"}], '@babel/preset-react'],
					plugins: [
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
            }
        ]
    },
    plugins: [
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
};
module.exports = [app , resplogin , respchangepassword, resphelp, inviteschangepassword];