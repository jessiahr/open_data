module.exports =
  methods:
    getDatastores: (params = {}, callback)->
      @$http['get'] "/api/datastores", params
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
