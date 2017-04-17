module.exports =
  mixins: [require('./mixins/datastore_mixin')]
  data: ->
    datastores: []
    datastore: null
  ready: ->
    @getDatastores({}, (data) =>
      @datastores = data.data
      console.log data
    )
    @getDatastore(1, {}, (data) =>
      @datastore = data.data
      console.log data
    )
  methods:
    getTopicData: ->
        @getTopic(@datastore, {}, (data) =>
          @datastore = data.data
          console.log data
        )
    create: ->
      datastore = {
        hostname: "localhost"
        database: "postgres"
        username: "postgres"
        password: "postgres"
        schema: {
          model: "thing",
          fields: [
            {
              name: "first_name"
              type: "string"
            }
          ]
        }
      }
      @createDatastore({datastore:datastore}, (data) =>
        console.log "created!", data
      )
  # computed:
  #   filtered_by_search: ->
  #     return @definitions if @search_field == ""
  #     @definitions.filter (definition) =>
  #       console.log definition
  #       definition[0].toLowerCase().replace(" ", "").includes(@search_field.toLowerCase().replace(" ", ""))
  # methods:
  #   showDetail: (audit)->
  #     @$router.go({ name: 'audit_show', params: { id: audit.id}})
  template: """
<a @click="create" >create</a>

<a @click="getTopicData" >get topic</a>
  """
