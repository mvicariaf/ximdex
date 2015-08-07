// Generated by CoffeeScript 1.8.0
angular.module('ximdex.main.controller').controller('AdvancedSearchModalCtrl', [
  '$scope', '$modalInstance', '$filter', '$http', 'xUrlHelper', '$window', '$modal', 'xMenu', 'xTabs', function($scope, $modalInstance, $filter, $http, xUrlHelper, $window, $modal, xMenu, xTabs) {
    var postLoadActions, queryToString, url, urlDeleteSavedFilter, urlListFilters, urlToSave;
    $scope.filters = [];
    $scope.condition = 'and';
    $scope.results = null;
    $scope.selected = [];
    $scope.lastSearches = $window.com.ximdex.session.get('last.searches') || [];
    $scope.savedFilters = [];
    url = xUrlHelper.getAction({
      action: 'browser3',
      method: 'search'
    });
    urlToSave = xUrlHelper.getAction({
      action: 'browser3',
      method: 'addFilter'
    });
    urlListFilters = xUrlHelper.getAction({
      action: 'browser3',
      method: 'listFilters'
    });
    urlDeleteSavedFilter = xUrlHelper.getAction({
      action: 'browser3',
      method: 'deleteFilter'
    });
    $scope.addFilter = function() {
      $scope.filters.push({
        'field': 'name',
        'comparation': 'contains',
        'nodetype_comparation': 'equal',
        'date_comparation': 'equal',
        'content': '',
        'nodetype_content': '5022',
        'date_content': $filter('date')(new Date, 'dd/MM/yyyy'),
        'date_content_to': $filter('date')(new Date, 'dd/MM/yyyy')
      });
    };
    $scope.deleteFilter = function(index) {
      $scope.filters.splice(index, 1);
      if ($scope.filters.length === 0) {
        $scope.addFilter();
      }
    };
    $scope.addFilter();
    $scope.ok = function() {
      $modalInstance.close();
    };
    $scope.cancel = function() {
      $modalInstance.dismiss('cancel');
    };
    $scope.updateSavedFilters = function() {
      return $http({
        method: 'GET',
        url: urlListFilters
      }).success(function(data, status) {
        $scope.savedFilters = data;
      }).error(function(data, status) {});
    };
    $scope.updateSavedFilters();
    $scope.deleteSavedFilter = function(id) {
      var modalInstance;
      modalInstance = $modal.open({
        animation: true,
        templateUrl: $window.X.baseUrl + '/inc/js/angular/templates/confirmDeleteFilterModal.html',
        controller: 'ConfirmDeleteFilterModalCtrl',
        size: 'sm',
        resolve: {},
        windowClass: "confirm-delete-filter"
      });
      return modalInstance.result.then((function(name) {
        return $http({
          method: 'POST',
          url: urlDeleteSavedFilter,
          data: $.param({
            "filterid": id
          }),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }
        }).success(function(data, status) {
          $scope.updateSavedFilters();
        }).error(function(data, status) {});
      }), function() {});
    };
    $scope.saveQuery = function() {
      var modalInstance;
      modalInstance = $modal.open({
        animation: true,
        templateUrl: $window.X.baseUrl + '/inc/js/angular/templates/enterNameFilterModal.html',
        controller: 'EnterNameFilterModalCtrl',
        size: 'sm',
        resolve: {
          condition: function() {
            return $scope.condition;
          },
          filters: function() {
            return $scope.filters;
          },
          urlToSave: function() {
            return urlToSave;
          }
        },
        windowClass: "enter-name"
      });
      return modalInstance.result.then((function() {
        $scope.updateSavedFilters();
      }), function() {});
    };
    queryToString = function(q) {
      var f, k, res, _i, _len, _ref;
      res = '';
      _ref = q.query.filters;
      for (k = _i = 0, _len = _ref.length; _i < _len; k = ++_i) {
        f = _ref[k];
        if (k !== 0) {
          res += ' ';
        }
        res += f.field + ' ' + f.comparation;
        if (f.to) {
          res += ' ' + f.from;
        } else {
          res += ' ' + f.content;
        }
        if (k !== q.query.filters.length - 1) {
          res += ' ' + q.query.condition;
        }
      }
      return res;
    };
    $scope.search = function(query) {
      var f, filter, q, stringQuery;
      stringQuery = '';
      q = {
        handler: 'SQL',
        output: 'JSON',
        query: {
          'parentid': '10000',
          'depth': '0',
          'items': '50',
          'page': '1',
          'view': 'gridview',
          'condition': $scope.condition,
          'filters': []
        }
      };
      if (typeof query === 'string') {
        stringQuery = query;
      } else if (typeof query === 'object') {
        q.query.filters = query.filters;
        q.query.condition = query.condition;
        stringQuery = $.param(q);
        $scope.filters = angular.copy(query.filters);
      } else {
        for (f in $scope.filters) {
          if ($scope.filters.hasOwnProperty(f)) {
            filter = {};
            switch ($scope.filters[f].field) {
              case 'name':
              case 'path':
              case 'content':
              case 'tag':
              case 'url':
              case 'desc':
                filter.field = $scope.filters[f].field;
                filter.comparation = $scope.filters[f].comparation;
                filter.content = $scope.filters[f].content;
                filter.from = $scope.filters[f].content;
                break;
              case 'nodetype':
                filter.field = $scope.filters[f].field;
                filter.comparation = $scope.filters[f].nodetype_comparation;
                filter.content = $scope.filters[f].nodetype_content;
                filter.from = $scope.filters[f].nodetype_content;
                break;
              case 'creation':
              case 'versioned':
              case 'publication':
                filter.field = $scope.filters[f].field;
                filter.comparation = $scope.filters[f].date_comparation;
                filter.content = $scope.filters[f].date_content;
                filter.from = $scope.filters[f].date_content;
                filter.to = $scope.filters[f].date_content_to;
            }
            q.query.filters.push(filter);
          }
        }
        stringQuery = $.param(q);
      }
      return $http({
        method: 'POST',
        url: url,
        data: stringQuery,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      }).success(function(data, status) {
        var title;
        $scope.selectNone();
        $scope.results = data;
        title = queryToString(q);
        if (typeof query === 'undefined' && ($scope.lastSearches.length === 0 || $scope.lastSearches[0].title !== title)) {
          $scope.lastSearches.unshift({
            title: title,
            filter: {
              condition: $scope.condition,
              filters: $scope.filters
            }
          });
          if ($scope.lastSearches.length > 6) {
            $scope.lastSearches.pop();
          }
          $window.com.ximdex.session.set('last.searches', $scope.lastSearches, '1d');
        }
      }).error(function(data, status) {});
    };
    $scope.updateView = function() {
      return $http({
        method: 'POST',
        url: url,
        data: $.param({
          handler: 'SQL',
          output: 'JSON',
          query: $scope.results.query
        }),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      }).success(function(data, status) {
        $scope.selectNone();
        $scope.results = data;
      }).error(function(data, status) {});
    };
    $scope.selectNode = function(node, event) {
      var n;
      if (event.ctrlKey) {
        if ($scope.isSelected(node)) {
          for (n in $scope.selected) {
            if ($scope.selected.hasOwnProperty(n) && $scope.selected[n].nodeid === node.nodeid) {
              $scope.selected.splice(n, 1);
              return;
            }
          }
        } else {
          $scope.selected.push(node);
        }
      } else {
        $scope.selected = [node];
      }
    };
    $scope.isSelected = function(node) {
      var n;
      for (n in $scope.selected) {
        if ($scope.selected.hasOwnProperty(n) && $scope.selected[n].nodeid === node.nodeid) {
          return true;
        }
      }
      return false;
    };
    $scope.selectAll = function() {
      var n;
      var n;
      for (n in $scope.results.data) {
        if ($scope.results.data.hasOwnProperty(n) && $scope.isSelected($scope.results.data[n])) {
          $scope.selected.splice(n, 1);
          return;
        }
      }
      for (n in $scope.results.data) {
        if ($scope.results.data.hasOwnProperty(n)) {
          $scope.selected.push($scope.results.data[n]);
        }
      }
    };
    $scope.selectNone = function() {
      $scope.selected = [];
    };
    $scope.invertSelection = function() {
      var n, newSelection;
      newSelection = [];
      for (n in $scope.results.data) {
        if ($scope.results.data.hasOwnProperty(n)) {
          if (!$scope.isSelected($scope.results.data[n])) {
            newSelection.push($scope.results.data[n]);
          }
        }
      }
      $scope.selected = newSelection;
    };
    $scope.openMenu = function(node, event) {
      var data, i, len, n, nodeToSearch, ref;
      $scope.selectNode(node, event);
      if ($scope.selected[0].nodeid === null | $scope.selected[0].nodetypeid === null | $scope.selected[0].nodeid === '0') {
        return;
      }
      nodeToSearch = $scope.selected[0].nodeid;
      if ($scope.selected.length > 1) {
        ref = $scope.selected.slice(1);
        i = 0;
        len = ref.length;
        while (i < len) {
          n = ref[i];
          nodeToSearch += '-' + n.nodeid;
          i++;
        }
      }
      if ($window.com.ximdex.nodeActions[nodeToSearch] == null) {
        $http.get(xUrlHelper.getAction({
          action: 'browser3',
          method: 'cmenu',
          nodes: $scope.selected
        })).success(function(data) {
          if (data) {
            $window.com.ximdex.nodeActions[nodeToSearch] = data;
            postLoadActions(data, event, $scope.selected);
          }
        });
      } else {
        data = $window.com.ximdex.nodeActions[nodeToSearch];
        postLoadActions(data, event, $scope.selected);
      }
      return false;
    };
    postLoadActions = function(data, event, selectedNodes) {
      if (data == null) {
        return;
      }
      if (event.pointers != null) {
        data.left = event.pointers[0].clientX + ($window.document.documentElement.scrollLeft ? $window.document.documentElement.scrollLeft : $window.document.body.scrollLeft);
        data.top = event.pointers[0].clientY + ($window.document.documentElement.scrollTop ? $window.document.documentElement.scrollTop : $window.document.body.scrollTop);
      }
      if (event.clientX != null) {
        data.left = event.clientX + ($window.document.documentElement.scrollLeft ? $window.document.documentElement.scrollLeft : $window.document.body.scrollLeft);
        data.top = event.clientY + ($window.document.documentElement.scrollTop ? $window.document.documentElement.scrollTop : $window.document.body.scrollTop);
      }
      xMenu.open(data, selectedNodes, xTabs.pushTab);
      data = null;
    };
    $scope.isLoading = function() {
      return $http.pendingRequests.length > 0;
    };
  }
]);

angular.module('ximdex.main.controller').controller('EnterNameFilterModalCtrl', [
  '$scope', '$modalInstance', '$http', 'condition', 'filters', 'urlToSave', function($scope, $modalInstance, $http, condition, filters, urlToSave) {
    $scope.name = '';
    $scope.error = false;
    $scope.ok = function() {
      $http({
        method: 'POST',
        url: urlToSave,
        data: $.param({
          filter: {
            condition: condition,
            filters: filters
          },
          handler: 'SQL',
          output: 'JSON',
          name: $scope.name
        }),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      }).success(function(data, status) {
        var _ref;
        if ((((_ref = data[0]) != null ? _ref.message : void 0) != null) && data[0].message.length > 0) {
          $scope.error = true;
        } else {
          $modalInstance.close();
        }
      }).error(function(data, status) {});
    };
    $scope.cancel = function() {
      $modalInstance.dismiss('cancel');
    };
  }
]);

angular.module('ximdex.main.controller').controller('ConfirmDeleteFilterModalCtrl', [
  '$scope', '$modalInstance', function($scope, $modalInstance) {
    $scope.ok = function() {
      $modalInstance.close($scope.name);
    };
    $scope.cancel = function() {
      $modalInstance.dismiss('cancel');
    };
  }
]);
