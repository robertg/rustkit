window.RustKit.controller 'MainController', ['$document', '$scope', 'http', '$sce', 'Base64', 'Constants', ($document, $scope, http, $sce, Base64, Constants) ->
  $scope.search = {input: ""} #Model for text search
  $scope.perPage = 20
  $scope.currPage = 1
  $scope.totalPages = 1
  $scope.currResults = []
  $scope.loading = true
  $scope.failed = false
  converter = new Markdown.Converter()

  $scope.search = (value) ->
    $scope.currPage = 1
    $scope.totalPages = 1
    $scope.currResults = []
    $scope.loading = true
    $scope.failed = false


    if value && value.length > 0
      http.post '/api/search/0', {query:value}, (response) ->
        setupPaginator(response.results, response.all_results_size)
        $scope.failed = response.all_results_size == 0
        $scope.loading = false
    else
      http.get '/api/libraries/0', (response) ->
        setupPaginator(response.results, response.all_results_size)
        $scope.failed = $scope.all_results_size == 0
        $scope.loading = false

  $scope.nextPage = ->
    return if $scope.currPage >= $scope.totalPages

    deferred = =>
      $scope.currPage += 1
      computeCurrentResults()
      $document.scrollTop(0,400)

    if ($scope.currPage+1)*$scope.perPage > $scope.results.length
      #We need to get the next page.
      debugger
      http.get "/api/libraries/#{Math.floor($scope.results.length/Constants.per_page)}", (data) ->
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

  $scope.init = (data) -> #Set up default page
    setupPaginator(data.results, data.all_results_size)
    $scope.allSize = data.all_results_size
    angular.element(document.getElementById('body')).removeAttr("ng-init") #Remove that embedded data from the DOM.
    $scope.loading = false
    return
]
