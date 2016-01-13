// Generated by CoffeeScript 1.8.0
angular.module("ximdex.common.directive").directive("ximAssocNodes", [
  "xTranslate", "$window", "$http", "xUrlHelper", "xMenu", "$document", "$timeout", "$q", "xTabs", "$rootScope", function(xTranslate, $window, $http, xUrlHelper, xMenu, $document, $timeout, $q, xTabs, $rootScope) {
    var base_url;
    base_url = $window.X.baseUrl;
    return {
      templateUrl: base_url + '/inc/js/angular/templates/ximAssocNodes.html',
      restrict: "E",
      replace: true,
      scope: {
        donothing: '@donothing'
      },
      controller: "AssocNodesCtrl",
      controllerAs: "ctrl1"
    };
  }
]);
