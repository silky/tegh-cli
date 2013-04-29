mdns = require 'mdns'
st = require '../node_modules/mdns/lib/service_type'
EventEmitter = require('events').EventEmitter

module.exports = class ConstructDiscoverer extends EventEmitter
  constructor: ->
    @list = []
    # Watch all construct servers on the network
    @mdns = mdns.createBrowser( st.protocolHelper('_tcp')('_construct') )
    @mdns
      .on('serviceUp', @_addServer)
      .on('serviceDown', @_rmServer)
      .start()

  _addServer: (service) =>
    console.log service
    @list.push service
    @emit "serviceUp", service

  _rmServer: (rm) =>
    console.log @mdns
    for service, i in @list
      console.log rm
      services.remove(service) if service.fullname == rm.fullname
    @emit "serviceDown", service