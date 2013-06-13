handleify = require 'handleify'
coffeeify = require 'coffeeify'
uglify = require 'uglify-js2'
shim = require 'browserify-shim'

module.exports = (grunt)->


  @initConfig
    regarde:
      styles:
        files: ['./public/stylesheets/**/*']
        tasks: ['clean:styles', 'livereload']
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
  @loadTasks 'tasks'

  @registerTask 'default', ['clean', 'markdown', 'browserify2:dev', 'express:app', 'livereload-start', 'regarde']
  @registerTask 'build', ['clean', 'markdown', 'browserify2:build']
  @registerTask 'serve', ['express:app', 'express-keepalive']
