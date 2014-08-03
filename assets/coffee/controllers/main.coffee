window.RustKit.controller 'MainController', ['$scope', '$http', '$sce', 'Base64', ($scope, $http, $sce, Base64) ->
  $scope.search = {input: ""} #Model for text search
  $scope.perPage = 20

  $scope.search = (value) ->
    console.log value

  $scope.nextPage = ->
    deferred = =>
      $scope.currPage += 1
      computeCurrentResults()

    return if $scope.currPage >= $scope.totalPages
    if ($scope.currPage+1)*$scope.perPage > $scope.results.length
      $http({method: 'GET', url: "/api/libraries/#{Math.floor($scope.currResults.length/200)+1}"}).success((data, status, headers, config) ->
        $scope.results = data.results.map (result) ->
          result.content = $sce.trustAsHtml(converter.makeHtml(Base64.b64_to_utf8(result.content))) if result.content
          result
        deferred()
      ).error(->
        console.log 'FATAL ERROR OCCURRED.'
      )
    else
      deferred()

  $scope.previousPage = ->
    return if $scope.currPage <= 1
    $scope.currPage -= 1
    computeCurrentResults()

  computeCurrentResults = ->
    $scope.currResults = $scope.results[(($scope.currPage-1)*$scope.perPage)...($scope.currPage*$scope.perPage)]

  setupPaginator = (data, all_size) ->
    $scope.currPage = 1
    $scope.totalPages = 0
    $scope.currResults = []

    converter = new Markdown.Converter()
    $scope.results = data.map (result) ->
      result.content = $sce.trustAsHtml(converter.makeHtml(Base64.b64_to_utf8(result.content))) if result.content
      result
    $scope.totalPages = Math.ceil(all_size/$scope.perPage)
    $scope.totalSize = all_size
    $scope.all_size
    computeCurrentResults()

  $http({method: 'GET', url: '/api/libraries/0'}).success((data, status, headers, config) ->
    setupPaginator(data.results, data.all_results_size)
  ).error(->
    console.log 'FATAL ERROR OCCURRED.'
  )
]
