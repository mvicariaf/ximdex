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
namespace Ximdex\Utils\Logs;



class Layout_PHP extends Layout
{

    public function __construct($template)
    {
        parent::__construct($template);
    }


    function & format(&$event)
    {

        $string = $this->_template;

        $level = array();
        $level[LOGGER_LEVEL_DEBUG] = 'PHP Debug';
        $level[LOGGER_LEVEL_INFO] = 'PHP User Notice';
        $level[LOGGER_LEVEL_WARNING] = 'PHP User Warning';
        $level[LOGGER_LEVEL_ERROR] = 'PHP User Error';
        $level[LOGGER_LEVEL_FATAL] = 'PHP Fatal';

        // [$date $hour] $priority_text: $message in $file($line)
        // [%d %t] %p: %m in %f(%l)
        $string = str_replace("%fn", $event->getParam("function"), $string);
        $string = str_replace("%c", $event->getParam("class"), $string);
        $string = str_replace("%f", $event->getParam("file"), $string);
        $string = str_replace("%l", $event->getParam("line"), $string);
        $string = str_replace("%m", $event->getParam("message"), $string);
        $string = str_replace("%p", $level[$event->getParam("priority")], $string);
        $string = str_replace("%d", date('d-M-Y'), $string);
        $string = str_replace("%t", $event->getParam("time"), $string);

        return $string;
    }

}