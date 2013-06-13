Backbone = require 'backbone'
try Backbone.$ = require '$' catch e
_ = require 'underscore'

NavBarView = require '../navbar/navbarview.coffee'
CompositeView = require 'chalice-compositeview'
View = require 'chalice-view'
Router = require 'chalice-client'

# clientTemplate = require '../pages/client.html'
# compositeTemplate = require '../pages/composite.html'
# serverTemplate = require '../pages/server.html'
# viewTemplate = require '../pages/view.html'
startTemplate = require '../pages/readme.html'

class Application extends Router

  uniqueName: 'app'

  getAppView: ->
    new CompositeView
      className: 'composite-view app-view'

  getNavigationView: ->
    new NavBarView
      collection: @pages

  fetcher: ->
    # dont need to fetch anything here.
    @trigger 'doneFetch'

  initialize: ->
    @pages = new Backbone.Collection [
          slug: 'view'
          title: 'View'
        ,
          slug: 'compositeview'
          title: 'Composite View'
        ,
          slug: 'client'
          title: 'Client'
        ,
          slug: 'server'
          title: 'Server'
      ]
    @appView.addView @getNavigationView()
    this

  swap: ->
    # scroll to top on desktop
    if window?.innerWidth > 768
      window.scrollTo 0, 0
    super

  routes:
    '': 'gettingStarted'
    'client': 'client'
    'server': 'server'
    'view': 'viewRoute'
    'compositeview': 'composite'
    'shared': 'shared'

  gettingStarted: ->
    @swap new View template: startTemplate
    @fetcher()

  client: ->
    @swap new View template: clientTemplate
    @fetcher()

  server: ->
    @swap new View template: serverTemplate
    @fetcher()

  composite: ->
    @swap new View template: compositeTemplate
    @fetcher()

  viewRoute: ->
    @swap new View template: viewTemplate
    @fetcher()

makeApplication = ->
  new Application

Backbone.$? ->
  makeApplication()
  Backbone.history.start pushState: yes

makeApplication() if not Backbone.$
