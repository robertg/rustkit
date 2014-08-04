window.RustKit.factory 'http', ['$http', ($http) -> #A $http wrapper that saves keystrokes and human error
  get:(uri, callback) ->
    $http({method: 'GET', url: uri}).success((data, status, headers, config) ->
      callback(data)
    ).error(->
      console.log 'FATAL ERROR OCCURRED WITH $http during GET.'
    )
  post:(uri, data, callback) ->
    $http({method: 'POST', url: uri, data: data}).success((data, status, headers, config) ->
      callback(data)
    ).error(->
      console.log 'FATAL ERROR OCCURRED WITH $http during POST.'
    )
]
