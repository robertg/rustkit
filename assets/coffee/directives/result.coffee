window.RustKit.directive 'searchResult', [->
  restrict: 'E'
  scope:
    result: '='
  templateUrl: 'result.html'
  link: (scope, element) ->
    scope.showReadme = false
    scope.search = scope.$parent.search
    scope.toggleExpand = ->
      scope.showReadme = !scope.showReadme
]
