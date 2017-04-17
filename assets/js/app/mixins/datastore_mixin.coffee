module.exports =
  methods:
    getDatastores: (params = {}, callback)->
      @$http['get'] "/api/datastores", params
        .then (resp) ->
          callback(resp.data)
        .catch (resp) ->
          console.log resp
    getDatastore: (id, params = {}, callback)->
      @$http['get'] "/api/datastores/#{id}", params
        .then (resp) ->
          callback(resp.data)
        .catch (resp) ->
          console.log resp
    createDatastore: (params = {}, callback)->
      @$http['post'] "/api/datastores", params
        .then (resp) ->
          callback(resp.data)
        .catch (resp) ->
          console.log resp
    getDatastoreTopic: (id, params = {}, callback)->
      @$http['get'] "/api/datastores/#{id}/#{topic}", params
        .then (resp) ->
          callback(resp.data)
        .catch (resp) ->
          console.log resp
