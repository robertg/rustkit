window.RustKit.controller 'MainController', ['$document', '$scope', 'http', '$sce', 'Base64', ($document, $scope, http, $sce, Base64) ->
  $scope.search = {input: ""} #Model for text search
  $scope.perPage = 20
  sizeFromBackend = 200
  $scope.currPage = 1
  $scope.totalPages = 0
  $scope.currResults = []
  converter = new Markdown.Converter()

  $scope.search = (value) ->
    console.log value

  $scope.nextPage = ->
    return if $scope.currPage >= $scope.totalPages

    deferred = =>
      $scope.currPage += 1
      computeCurrentResults()
      $document.scrollTop(0,400)

    if ($scope.currPage+1)*$scope.perPage > $scope.results.length
      #We need to get the next page.
      http.get "/api/libraries/#{Math.floor($scope.currResults.length/sizeFromBackend)+1}", (data) ->
        $scope.results = $scope.results.concat(data.results.map (result) ->
          result.content = $sce.trustAsHtml(converter.makeHtml(Base64.b64_to_utf8(result.content))) if result.content
          result
        )
        deferred()
    else
      deferred()

  $scope.previousPage = ->
    $document.scrollTop(0,400)
    return if $scope.currPage <= 1
    $scope.currPage -= 1
    computeCurrentResults()

  computeCurrentResults = ->
    $scope.currResults = $scope.results[(($scope.currPage-1)*$scope.perPage)...($scope.currPage*$scope.perPage)]

  setupPaginator = (data, all_size) ->
    $scope.results = data.map (result) ->
      result.content = $sce.trustAsHtml(converter.makeHtml(Base64.b64_to_utf8(result.content))) if result.content
      result
    $scope.totalPages = Math.ceil(all_size/$scope.perPage)
    $scope.totalSize = all_size
    $scope.all_size
    computeCurrentResults()

  http.get '/api/libraries/0', (data) -> #Set up default page
    setupPaginator(data.results, data.all_results_size)

]
