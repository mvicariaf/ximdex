<?php

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
use Ximdex\Logger;
use Ximdex\Models\RelRolesActions;
use Ximdex\Modules\Module;


class Module_ximPUBLISHtools extends Module {

    const PUB_REPORT_ACTION_ID = '7500';
    const PUB_REPORT_HISTORY_ID = '7501';

    public function __construct () {
        parent::__construct('ximPUBLISHtools', dirname(__FILE__));
    }

    function install() {
        $this->loadConstructorSQL("ximPUBLISHtools.constructor.sql");
        return parent::install();
    }

    // Uninstalling without disabling not allowed for this module.
    function uninstall() {
        if (ModulesManager::isEnabled($this->getModuleName())) {
            ModulesManager::disableModule($this->getModuleName());
        }

        $this->loadDestructorSQL("ximPUBLISHtools.destructor.sql");
        parent::uninstall();
    }

    // It's necessary to enable actions on this method, not on 'install' method.
    // Due to recent lmd class removal, unique way to do this is via DB class
    function enable() {
        Logger::info("Module_ximPUBLISHtools enable");
        $db = new DB();
        $sql = array();

        // Pub. Report
        $sql['Creating ximPUBLISH report action'] = "INSERT INTO Actions
		(IdAction,IdNodeType,Name,Command,Icon,Description,Sort,Module,Multiple)
		VALUES ('" . self::PUB_REPORT_ACTION_ID . "','" . \Ximdex\Services\NodeType::SERVER 
		      . "','Publishing report','managebatchs','publicate_section.png',
		'View documents in publishing queue',100,'ximPUBLISHtools',0)";

        $sql['Enabling ximPUBLISH report action'] = "INSERT INTO RelRolesActions
		(IdRel,IdRol,IdAction,IdState,IdContext)
		VALUES (NULL,201," . self::PUB_REPORT_ACTION_ID . ",7,1)";

        $sql['Creating ximPUBLISH history action'] = "INSERT INTO Actions
		(IdAction,IdNodeType,Name,Command,Icon,Description,Sort,Module,Multiple)
		VALUES ('" . self::PUB_REPORT_HISTORY_ID . "','" . \Ximdex\Services\NodeType::SERVER 
		      . "','Publishing history','batchhistory','publicate_section.png',
		'View document Publishing history',100,'ximPUBLISHtools',0)";
        
		// commented temporally
		/*
        $sql['Enabling ximPUBLISH history action'] = "INSERT INTO RelRolesActions
		(IdRel,IdRol,IdAction,IdState,IdContext)
		VALUES (NULL,201," . self::PUB_REPORT_HISTORY_ID . ",7,1)";
        */
        foreach ($sql as $desc => $query) {
            if (!$db->Execute($query)) {
                Logger::error("Error $desc - $query");
                self::disable();
                die();
            }
        }

        Logger::info("Module_ximPUBLISHtools enabled successfully");
        return true;
    }

    // It's necessary to disable actions on this method, not on 'uninstall' method.
    // Due to recent lmd class removal, unique way to do this is via DB class
    function disable() {
        $db = new DB();
        $sql = array();
        $relRolesActions = new RelRolesActions();

        // Pub. Report
        $sql['Deleting ximPUBLISH report action'] = "DELETE FROM Actions WHERE IdAction = '" . self::PUB_REPORT_ACTION_ID . "'";
        $result = $relRolesActions->find('IdRel', 'IdAction = %s', array(self::PUB_REPORT_ACTION_ID), MONO);
        if ($result)
        {
        	$sql['Disabling ximPUBLISH report action'] = "DELETE FROM RelRolesActions WHERE IdRel = '" . $result[0] . "'";
        }

        $sql['Deleting ximPUBLISH history action'] = "DELETE FROM Actions WHERE IdAction = '" . self::PUB_REPORT_HISTORY_ID . "'";
        $result = $relRolesActions->find('IdRel', 'IdAction = %s', array(self::PUB_REPORT_HISTORY_ID), MONO);
        if ($result)
        {
        	$sql['Disabling ximPUBLISH history action'] = "DELETE FROM RelRolesActions WHERE IdRel = '" . $result[0] . "'";
        }
        
        foreach ($sql as $query) {
            $db->Execute($query);
        }
        Logger::info("Module_ximPUBLISHtools disabled successfully");

        parent::disable();
    }

}