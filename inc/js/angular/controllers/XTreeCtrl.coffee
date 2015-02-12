###*
\details &copy; 2011  Open Ximdex Evolution SL [http://www.ximdex.org]

Ximdex a Semantic Content Management System (CMS)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

See the Affero GNU General Public License for more details.
You should have received a copy of the Affero GNU General Public License
version 3 along with Ximdex (see LICENSE file).

If not, visit http://gnu.org/licenses/agpl-3.0.html.

@author Ximdex DevTeam <dev@ximdex.com>
@version $Revision$
###
angular.module("ximdex.main.controller").controller "XTreeCtrl", [
    "$scope", "xTranslate", "$window", "$http"
    "xUrlHelper", "xMenu", "$document", "$timeout", "$q", "xTabs", "$sce"
    ($scope, xTranslate, $window, $http, xUrlHelper, xMenu, $document, $timeout, $q, xTabs, $sce) ->

        delete Hammer.defaults.cssProps.userSelect

        #Nodes for project tab
        $scope.projects = null
        #Initial node for list view
        $scope.initialNodeList = null
        #The path to $scope.initialNodeList in array format
        $scope.breadcrumbs = []
        #Nodes for ccenter tab
        $scope.ccenter = null
        #Nodes for project tab
        $scope.modules = null
        #if true, TreeView is displayed else ListView
        $scope.treeMode = true
        #Cache for node actions
        $scope.nodeActions = []
        #Current selected nodes
        $scope.selectedNodes = []
        #Tab selected in the sidebar
        $scope.selectedTab = 1
        #Indicates the filter status
        $scope.filterMode = false
        dragStartPosition=0;
        $scope.expanded = true
        size = 0
        listenHidePanel = true

        canceler = $q.defer()

        actualFilter = ""

        #Load a new action in a new tab for some nodes
        loadAction = (action, nodes) ->
            xTabs.pushTab action, nodes
            return


        #Load initial values
        $http.get(xUrlHelper.getAction(
            action: "browser3"
            method: "read"
            id: "10000"
        )).success (data) ->
            if data
                $scope.projects = data
                $scope.projects.showNodes = true
            return

        $http.get(xUrlHelper.getAction(
            action: "browser3"
            method: "read"
            id: "2"
        )).success (data) ->
            $scope.ccenter = data  if data
            return

        $http.get(xUrlHelper.getAction(
            action: "moduleslist"
            method: "readModules"
        )).success (data) ->
            $scope.modules = data  if data
            return

        #Open/Close a node in the TreeView
        $scope.toggleNode = (node,event) ->
            event.preventDefault()
            node.showNodes = not node.showNodes
            $scope.loadNodeChildren node  if node.showNodes and not node.collection
            return


        #Load the children of a node. It can execute a callback function later
        $scope.loadNodeChildren = (node, callback) ->
            if node.loading | node.isdir == "0"
                if $scope.treeMode == false
                    $scope.initialNodeList = node
                    prepareBreadcrumbs()
                return
            node.loading = true
            node.showNodes = true
            canceler.resolve()
            canceler = $q.defer()
            if $scope.filterMode and $scope.selectedTab == 1
                node.collection = []
                url=xUrlHelper.getAction(
                        action: "browser3"
                        method: "readFiltered"
                        id: node.nodeid
                    ) + "&query=" + actualFilter
                $http.get(url, {timeout: canceler.promise}).success( (data) ->
                    node.loading = false
                    if data
                        node.collection = data.collection
                        node.children = data.children
                        node.state = data.state
                        if $scope.treeMode == false && $scope.selectedTab == 1
                            $scope.initialNodeList = node
                            prepareBreadcrumbs()
                        callback node.collection  if callback
                    cancel = null
                    return
                ).error (data) ->
                    node.loading = false
                    cancel = null
                    return

            else
                maxItemsPerGroup = parseInt($window.com.ximdex.preferences.MaxItemsPerGroup)
                fromTo = ""
                idToSend = node.nodeid
                if node.nodeid == "0" && node.startIndex? && node.endIndex?
                    fromTo = "&from=#{node.startIndex}&to=#{node.endIndex}"
                    idToSend = node.parentid
                $http.get(xUrlHelper.getAction(
                    action: "browser3"
                    method: "read"
                    id: idToSend
                )+"&items=#{maxItemsPerGroup}"+fromTo, {timeout: canceler.promise}).success((data) ->
                    node.loading = false
                    if data
                        node.collection = data.collection
                        node.children = data.children
                        node.state = data.state
                        if $scope.treeMode == false && $scope.selectedTab == 1
                            $scope.initialNodeList = node
                            prepareBreadcrumbs()
                        callback node.collection  if callback
                    cancel = null
                    return
                ).error (data) ->
                    node.loading = false
                    cancel = null
                    return

            return

        #Load the actions of a node and opens a context menu. It does a request if the actions aren't in cache.
        $scope.loadActions = (node, event) ->
            $scope.select node, event
            return if !$scope.selectedNodes[0].nodeid? | !$scope.selectedNodes[0].nodetypeid? | $scope.selectedNodes[0].nodeid == "0"
            nodeToSearch = $scope.selectedNodes[0].nodeid
            if $scope.selectedNodes.length > 1
                for n in $scope.selectedNodes[1..]
                    if $scope.selectedNodes[0].nodetypeid != n.nodetypeid
                        return
                    else
                        nodeToSearch += "-#{n.nodeid}"
            if not $scope.nodeActions[nodeToSearch]?
                $http.get(xUrlHelper.getAction(
                    action: "browser3"
                    method: "cmenu"
                    nodes: $scope.selectedNodes
                )).success (data) ->
                    if data
                        $scope.nodeActions[nodeToSearch] = data
                        postLoadActions(data, event, $scope.selectedNodes)
                    return
            else
                data = $scope.nodeActions[nodeToSearch]
                postLoadActions(data, event, $scope.selectedNodes)
            return false

        postLoadActions = (data, event, selectedNodes) ->
            return if data.length == 0
            if event.pointers?
                data.left = event.pointers[0].clientX + (if $window.document.documentElement.scrollLeft then $window.document.documentElement.scrollLeft else $window.document.body.scrollLeft)
                data.top = event.pointers[0].clientY + (if $window.document.documentElement.scrollTop then $window.document.documentElement.scrollTop else $window.document.body.scrollTop)
            data.expanded = "true"
            if event.clientX
                data.left = event.clientX + (if $window.document.documentElement.scrollLeft then $window.document.documentElement.scrollLeft else $window.document.body.scrollLeft)
                data.top = event.clientY + (if $window.document.documentElement.scrollTop then $window.document.documentElement.scrollTop else $window.document.body.scrollTop)
            if event.type == "tap"
                data.expanded = "false"
            xMenu.open data, selectedNodes, loadAction
            return

        #Global method to empty the actions cache
        $window.com.ximdex.emptyActionsCache = () ->
            $scope.nodeActions = []
            return

        #Set a node as selected
        $scope.select = (node,event) ->
            ctrl = if event.srcEvent? then event.srcEvent.ctrlKey else event.ctrlKey
            if ctrl
                for k, n of $scope.selectedNodes
                    if (!n.nodeFrom? && !node.nodeFrom? && !n.nodeTo? && !node.nodeTo? && n.nodeid == node.nodeid) | (n.nodeFrom? && node.nodeFrom? && n.nodeTo? && node.nodeTo? && n.nodeFrom == node.nodeFrom && n.nodeTo == node.nodeTo)
                        $scope.selectedNodes.splice k, 1 if (event.button? && event.button == 0) || (event.srcEvent? && event.srcEvent.button == 0)
                        return
                pushed = false
                for k, n of $scope.selectedNodes
                    if n.nodeid > node.nodeid
                        $scope.selectedNodes.splice k, 0, node
                        pushed = true
                        break
                if !pushed
                    $scope.selectedNodes.splice $scope.selectedNodes.length, 0, node
            else
                $scope.selectedNodes = [node]
            return

        #Reloads the children of a node
        $scope.reloadNode = (nodeId, callback) ->
            if nodeId?
                n = findNodeById nodeId, $scope.projects
                n = findNodeById nodeId, $scope.ccenter if n == null
                return if n == null
            else if $scope.selectedNodes.length == 1
                return if $scope.selectedNodes[0].isdir == "0"
                n = $scope.selectedNodes[0]
            else
                return
            n.showNodes = true
            n.collection = []
            $scope.loadNodeChildren n, callback

        $scope.navigateToNodeId = (nodeId) ->
            return if !nodeId?
            $http.get(xUrlHelper.getAction(
                method: "getTraverseForPath"
                id: nodeId
                options: [
                    ajax: "json"
                ]
            )).success (data) ->
                nodeList = data['nodes']
                callback = () ->
                    shifted = nodeList.shift()
                    if shifted?
                        $scope.reloadNode shifted.nodeid, callback
                    else
                        n = findNodeById nodeId, $scope.projects
                        n = findNodeById nodeId, $scope.ccenter if n == null
                        return if n == null
                        $scope.select n
                callback()
            return




        #Search nodes with a filter
        $scope.doFilter = () ->
            if $scope.filter == ""
                actualFilter = ""
                $scope.filterMode = false
                $scope.projects.showNodes = true
                $scope.projects.collection = []
                $scope.loadNodeChildren $scope.projects
            else if $scope.filter.length>2 and $scope.filter.match /^[\d\w_\.]+$/i
                actualFilter = $scope.filter
                $scope.filterMode = true
                $scope.projects.showNodes = true
                $scope.projects.collection = []
                $scope.loadNodeChildren $scope.projects
            $scope.selectedNodes = []
            return

        #Catches event dragstart on resizer bar
        $scope.dragStart = (event) ->
            if $scope.expanded
                dragStartPosition = angular.element('#angular-tree').width()
                angular.element('body').addClass 'noselect'
            return

        #Catches event drag on resizer bar
        $scope.drag = (e,width) ->
            if $scope.expanded
                x = e.deltaX + dragStartPosition
                x = $document.width()-17  if  x > $document.width()-17
                x = 270  if x < 270
                angular.element(e.target).css left: x + "px"
                angular.element('#angular-tree').css width: x + "px"
                angular.element('#angular-content').css left: (x + parseInt(width)) + "px"
            return

        $scope.dragEnd = () ->
            if $scope.expanded
                angular.element('body').removeClass 'noselect'
            return


        #Toggle autohide on sidebar
        $scope.toggleTree = () ->
            button = angular.element('#angular-tree-toggle')
            button.toggleClass "hide"
            button.toggleClass "tie"
            angular.element('#angular-tree').toggleClass "hideable"
            angular.element('#angular-content').toggleClass "hideable"
            button.toggleClass "hideable"
            $scope.expanded = !$scope.expanded
            size = angular.element('#angular-tree').width()
            if !$scope.expanded
                $scope.hideTree()

            return

        $scope.hideTree = () ->
            if !$scope.expanded && listenHidePanel
                a=7
                b=10+a
                angular.element('#angular-tree').css left: (-size-7) + "px"
                angular.element('#angular-content').css left: (b-7) + "px"
                $timeout(
                    () ->
                        listenHidePanel = false
                ,
                    500
                )
            return

        $scope.showTree = () ->
            if !$scope.expanded && !listenHidePanel
                angular.element('#angular-tree').css left: 0 + "px"
                angular.element('#angular-content').css left: (size+10+7) + "px"
                $timeout(
                    () ->
                        listenHidePanel = true
                ,
                    500
                )
            return

        #Toggles Treeview/ListView
        $scope.toggleView = () ->
            $scope.treeMode = !$scope.treeMode
            if $scope.treeMode == false && $scope.selectedTab == 1
                if $scope.selectedNodes.length > 0 && $scope.selectedNodes[0].path.slice(0,16) == "/Ximdex/Projects"
                    $scope.loadNodeChildren $scope.selectedNodes[0]
                else
                    $scope.loadNodeChildren $scope.projects
            return

        #Go to the selected node in the breadcrumbs
        $scope.goBreadcrums = (index) ->
            pathToNode = $scope.breadcrumbs.slice 1, index + 1
            actualNode = $scope.projects
            nodeFound = false
            while pathToNode.length > 0
                nodeFound = false
                for n, i in actualNode.collection
                    if (n.name == pathToNode[0] && $scope.filterMode == false) | (n.originalName == pathToNode[0] && $scope.filterMode == true)
                        actualNode = n
                        pathToNode.splice 0, 1
                        nodeFound = true
                        break
                return if nodeFound == false
            $scope.loadNodeChildren actualNode
            return

        #Transform a node path to array for the breadcrumbs
        prepareBreadcrumbs = () ->
            if $scope.initialNodeList.nodeid == "0"
                path = getFolderPath $scope.initialNodeList.collection[0].path
            else
                path = $scope.initialNodeList.path
            if path.slice(-1) == "/"
                path = path.substring(0, path.length-1)
            if path.slice(0,1) == "/"
                path = path.substring(1, path.length)
            b = path.split("/")
            b.splice 0, 1
            $scope.breadcrumbs = b
            if $scope.initialNodeList.isdir == "0"
                $scope.goBreadcrums b.length - 2
            return

        #Gets the folder path of a path
        getFolderPath = (path) ->
            n = path.lastIndexOf "/"
            return path.substring 0, n if n>0
            return path

        findNodeById = (nodeId, source) ->
            queue = [source]
            while queue.length > 0
                item = queue.pop()
                if item.nodeid == nodeId
                    return item
                else
                    if item.collection?
                        for i in item.collection
                            queue.push i
            return null

        $scope.$on 'nodemodified', (event, nodeId) ->
            node = findNodeById nodeId, $scope.projects
            node = findNodeById nodeId, $scope.ccenter if node == null
            return if node == null
            return if node.isdir == "0"
            $scope.selectedNodes = []
            node.showNodes = true
            node.collection = []
            $scope.loadNodeChildren node

        $scope.openModuleAction = (node) ->
            action =
                command: "moduleslist"
                name: node.name
                method: "opentab"
                params: [
                    modsel: node.name
                ]
            nodes = [
                nodeid: node.id
            ]
            xTabs.pushTab action, nodes
            return

        allowedHokey = true
        $scope.$parent.keydown = (event) ->
            return if !allowedHokey
            if event.altKey && event.ctrlKey && event.keyCode == 73 && $scope.selectedNodes.length > 0
                action =
                    command: 'infonode'
                    method: 'index'
                    name: _("Node Info")
                for n in $scope.selectedNodes
                    xTabs.pushTab action, [n]
                allowedHokey = false
                event.stopPropagation();
                event.preventDefault();
            return
        $scope.$parent.keyup = (event) ->
            allowedHokey = true
            return
]

angular.module("ximdex.main.controller").filter "nodeSelected", () ->
    (input, arr) ->
        for a in arr
            return true if (!a.nodeFrom? && !a.nodeTo? && !input.nodeFrom? && !input.nodeTo? && a.nodeid == input.nodeid) | (a.nodeFrom? && a.nodeTo? && input.nodeFrom? && input.nodeTo? && a.nodeFrom == input.nodeFrom && a.nodeTo == input.nodeTo)
        return false
