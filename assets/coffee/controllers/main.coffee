window.RustKit.controller 'MainController', ['$scope', '$http', ($scope, $http) ->
  console.log 'hello?'
  $http({method: 'GET', url: '/api/libraries'}).success((data, status, headers, config) ->
      console.log data
    ).error((data,status,headers,config) ->
      console.log 'err'
    )
]
