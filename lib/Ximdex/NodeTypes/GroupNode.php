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
 * @author Ximdex DevTeam <dev@ximdex.com>
 * @version $Revision$
 */

namespace Ximdex\NodeTypes;

use Ximdex\Models\Group;



/**
 * @brief Handles groups.
 *
 *  Its purpose is to share the permissions of operations with Nodes between different Users.
 */
class GroupNode extends Root
{

	/**
	 *  Constructor.
	 * @param object parentObj
	 */

	public function __construct($parentObj)
	{

		parent::__construct($parentObj);
	}

	/**
	 *  Calls to method for adding a new Group in the database.
	 * @param string name
	 * @param int parentID
	 * @param int nodeTypeID
	 * @param int stateID
	 * @return unknown
	 */

	function CreateNode($name = null, $parentID = null, $nodeTypeID = null, $stateID = null)
	{

		$grupo = new Group($this->parent->get('IdNode'));
		$grupo->CreateNewGroup($name, $this->parent->get('IdNode'));
		$this->updatePath();
	}

	/**
	 *  Calls to method for deleting.
	 * @return unknown
	 */

	function DeleteNode()
	{

		$grupo = new Group($this->parent->get('IdNode'));
		$grupo->DeleteGroup();
	}

	/**
	 *  Checks whether the Group belongs to GeneralGroup.
	 * @return bool
	 */

	function CanDenyDeletion()
	{

		$group = new Group();
		return ($this->parent->get('IdNode') == $group->GetGeneralGroup());
	}

	/**
	 *  Calls to method for updating the Name on the database.
	 * @param string name
	 * @return unknown
	 */

	function RenameNode($name = null)
	{

		$grupo = new Group($this->parent->get('IdNode'));
		$grupo->SetGroupName($name);
		$this->updatePath();
	}
}