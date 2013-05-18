View = require 'chalice-view'
template = require './navbar.hbs'
try $ = require '$'

class NavbarView extends View

  className: 'navbar-view'

  template: template

  afterRender: ->
    super
    @stopListening @collection
    @listenTo @collection, 'reset', @render

  getTemplateData: ->
    items: @collection?.toJSON()

module.exports = NavbarView
