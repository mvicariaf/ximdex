/**
 *  \details &copy; 2011  Open Ximdex Evolution SL [http://www.ximdex.org]
 *
 *  Ximdex a Semantic Content Management System (CMS)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as published
 *  by the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  See the Affero GNU General Public License for more details.
 *  You should have received a copy of the Affero GNU General Public License
 *  version 3 along with Ximdex (see LICENSE file).
 *
 *  If not, visit http://gnu.org/licenses/agpl-3.0.html.
 *
 *  @author Ximdex DevTeam <dev@ximdex.com>
 *  @version $Revision$
 */
ximdexInstallerApp.controller('InstallDatabaseController', ["$timeout", '$scope', 'installerService', "$q", "$window",
 function($timeout, $scope, installerService, $q, $window) {

    $scope.error=false;
    $scope.submit = false;
    $scope.root_user="root";
    $scope.name="ximdex";

    installerService.sendAction("checkHost").then(function(response) {
        if (response.data.success){
            $scope.host=response.data.host;
            $scope.port=response.data.port;
            $scope.hostCheck = true;
        }

    });

    $scope.processForm = function(){
        $scope.error="";
        $scope.loading = true;
        var index = 0;
        $scope.checkRootUser();
    };

    $scope.checkRootUser = function(){
        
        var params = "user="+$scope.root_user;
        params += "&pass="+$scope.root_pass;
        params += "&host="+$scope.host;
        params += "&port="+$scope.port;
        installerService.sendAction("checkUser",params).then(function(response) {
        if (response.data.success){
            $scope.checkExistDataBase();

        }else{
            $scope.loading = false;
            $scope.error = response.data.errors;
        }

    });
    };

    $scope.checkExistDataBase = function(){
        var params = "user="+$scope.root_user;
        params += "&pass="+$scope.root_pass;
        params += "&host="+$scope.host;
        params += "&port="+$scope.port;
        params += "&name="+$scope.name;
        installerService.sendAction("checkExistDataBase",params).then(function(response) {        
        if (response.data.success){
            $scope.installDataBase();
        }else{
            $scope.error = $scope.name+" database already exists";
            $scope.loading=false;
        }
     });
    };

    $scope.installDataBase = function(){
        var params = "user="+$scope.root_user;
        params += "&pass="+$scope.root_pass;
        params += "&host="+$scope.host;
        params += "&port="+$scope.port;
        params += "&name="+$scope.name;
        installerService.sendAction("createDataBase",params).then(function(response) {
        $scope.loading=false;
        if (response.data.success){

        }else{
            $scope.error = response.data.errors;
        }
    });
   
    }

}]);