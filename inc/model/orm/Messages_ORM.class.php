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
class Messages_ORM extends \Ximdex\Data\GenericData
{
    var $_idField = 'IdMessage';
    var $_table = 'Messages';
    var $_metaData = array(
        'IdMessage' => array('type' => "int(12)", 'not_null' => 'true', 'auto_increment' => 'true', 'primary_key' => true),
        'IdFrom' => array('type' => "int(12)", 'not_null' => 'true'),
        'IdOwner' => array('type' => "int(12)", 'not_null' => 'true'),
        'ToString' => array('type' => "varchar(255)", 'not_null' => 'false'),
        'Folder' => array('type' => "int(12)", 'not_null' => 'true'),
        'Subject' => array('type' => "varchar(255)", 'not_null' => 'false'),
        'Content' => array('type' => "blob", 'not_null' => 'false'),
        'IsRead' => array('type' => "int(1)", 'not_null' => 'true')
    );
    var $_uniqueConstraints = array();
    var $_indexes = array('IdMessage');
    var $IdMessage;
    var $IdFrom = 0;
    var $IdOwner = 0;
    var $ToString;
    var $Folder = 1;
    var $Subject;
    var $Content;
    var $IsRead = 0;
}
