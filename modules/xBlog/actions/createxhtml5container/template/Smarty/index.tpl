{**
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
 *}

<form method="post" id="cdx_form" action="{$action_url}">
	<input type="hidden" name="nodeid" value="{$idNode}"/>

	<div class="action_header">
		<h2>{t}Add new xHTML{/t}</h2>
		
	</div>

	<div class="action_content icon">
	<fieldset>
		<div class="input-select icon document">
				<input type="text" name="name" id="docname" class="validable not_empty full-size" placeholder="{t}Name of your document{/t}"/>

			</div>
	
	{include file="`$_APP_ROOT`/modules/xBlog/actions/createxhtml5container/template/Smarty/_ximdoc_languages.tpl"}
	</fieldset>

	</div>
	<fieldset class="buttons-form positioned_btn">
			{button label="Create" class='validate btn main_action' }{*message="Do you wan to create the XML document?"*}
		</fieldset>	
</form>
