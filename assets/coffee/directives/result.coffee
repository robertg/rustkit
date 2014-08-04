window.RustKit.directive 'searchResult', [->
  restrict: 'E'
  scope:
    result: '='
  templateUrl: 'result.html'
  link: (scope, element) ->
    scope.showReadme = false
    scope.toggleExpand = ->
      scope.showReadme = !scope.showReadme
]
