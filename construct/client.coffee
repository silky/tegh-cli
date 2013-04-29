EventEmitter = require('events').EventEmitter
WebSocketClient = require('websocket').client

stdout = process.stdout

module.exports = class ConstructClient extends EventEmitter
  constructor: (@host, @port) ->
    @socket = new WebSocketClient(webSocketVersion: 8)
    @socket.on "connect", @_onConnect
    @socket.on 'connectFailed', @_onConnectionFailed
    #new WebSocketClient "ws://#{@host}:8000/#{@port}", "construct"
    url = "ws://#{@host}:#{@port}/socket?user=admin&password=admin"
    @socket.connect url, "construct.text.0.0.1"

  send: (msg) =>
    @connection.sendUTF msg

  _onConnect: (@connection) =>
    @emit "connect", @connection
    @connection.on 'message', @_onMessage
    @connection.on 'close', @_onClose

  _onConnectionFailed: (error) =>
    stdout.write 'Connect Error: ' + error.toString() + "\n"
    process.exit()

  _onMessage: (m) =>
    message = JSON.parse m.utf8Data
    @emit "message", message
    for k,v of message
      k = "construct_#{k}" if k == "error"
      @emit k, v

  _onClose: () =>
    @emit "close"
    