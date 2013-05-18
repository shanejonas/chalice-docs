handleify = require 'handleify'
coffeeify = require 'coffeeify'
uglify = require 'uglify-js2'
shim = require 'browserify-shim'

module.exports = (grunt)->


  @initConfig
    regarde:
      styles:
        files: ['stylesheets/**/*']
        tasks: ['clean:styles', 'stylus:dev', 'livereload']
      app:
        files: ['src/**/*']
        tasks: ['clean:build', 'browserify2:dev', 'express:app', 'livereload']
    express:
      app: './server.coffee'
    clean:
      pages: ['src/pages/']
      build: ['public/application.js']
      styles: ['public/style.css']
    markdown:
      readme:
        files: ['./README.md']
        dest: './src/pages'
    browserify2:
      options:
        entry: './src/app/application.coffee'
        compile: './public/application.js'
        beforeHook: (bundle)->
          bundle.transform coffeeify
          bundle.transform handleify
          shim bundle,
            $: path: './vendor/zepto', exports: 'Zepto'
      dev:
        debug: yes
      build:
        debug: no
        compile: './public/application.js'
        afterHook: (src)->
          result = uglify.minify src, fromString: true
          result.code
    stylus:
      dev:
        options:
          debug: yes
          use: ['nib']
          import: ['nib']
        files:
          './public/style.css': './stylesheets/index.styl'
      build:
        options:
          debug: no
          use: ['nib']
          import: ['nib']
        files:
          './public/style.css': './stylesheets/index.styl'
    docco:
      docs:
        src: ['node_modules/chalice-*/src/*.coffee']
        options:
          template: './resources/docco-template.jst'
          output: 'src/pages'
    watch:
      scripts:
        files: ['**/*.coffee'],
        tasks: ['default']

  @loadNpmTasks 'grunt-contrib-clean'
  @loadNpmTasks 'grunt-contrib-stylus'
  @loadNpmTasks 'grunt-contrib-livereload'
  @loadNpmTasks 'grunt-browserify2'
  @loadNpmTasks 'grunt-regarde'
  @loadNpmTasks 'grunt-devtools'
  @loadNpmTasks 'grunt-markdown'
  @loadNpmTasks 'grunt-docco'
  @loadTasks 'tasks'

  @registerTask 'default', ['clean', 'stylus:dev', 'docco', 'markdown', 'browserify2:dev', 'express:app', 'livereload-start', 'regarde']
  @registerTask 'build', ['clean', 'docco', 'markdown', 'stylus:build', 'browserify2:build']
  @registerTask 'serve', ['express:app', 'express-keepalive']
