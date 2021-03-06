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
?>

<form method="post" action=".">
    <input type="hidden" name="method" value="<?php echo $goMethod ?>">
	<h2>Installation finished!</h2>
	<p>You've succesfully installed Ximdex CMS on your server.<br/>Log in and discover a different way to manage your content and data.</p>
	<?php if (!isset($_SERVER['DOCKER_CONF_HOME'])) { ?>
	<p>Enable decoupled dynamic semantic publishing by adding these lines to your root crontab (# crontab -e):</p>
	<pre class="cide">* * * * * (php <?php echo XIMDEX_ROOT_PATH ?>/modules/ximNEWS/actions/generatecolector/automatic.php) 2&gt;&amp;1</pre>
	<pre>* * * * * (php <?php echo XIMDEX_ROOT_PATH ?>/modules/ximSYNC/scripts/scheduler/scheduler.php) 2>&amp;1</pre>
	<?php } ?>
	<button class="launch_ximdex action_launcher" id="submitButton" onclick="document.forms[0].submit(); return false;">
          Get started
    </button>
</form>