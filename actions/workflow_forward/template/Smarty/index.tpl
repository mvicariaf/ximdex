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
<form method="post" name="workflow_forward" action="{$action_url}">

	<input type="hidden" name="nodeid" value="{$id_node}" />
	<input type="hidden" name="default_message" value="{$defaultMessage}">
	<input type="hidden" name="groupid" value="" />
	<input type="hidden" name="state" value="{$state}" />
	<input type="hidden" name="stateid" value="{$stateid}" />
	<div class="action_header">
		<h2>{t}Publication period{/t}</h2>
		<fieldset class="buttons-form">
			{button class="validate publicate-button  btn main_action" label="Publish"}
		</fieldset>
	</div>
	<div class="message warning-message">
		{if $hasDisabledFunctions}
		<div class="disable-functions-alert">
			pcntl_fork and pcntl_waitpid required functions are disabled. This can cause a slow and unstable publishing. Please, check the php.ini configuration file or contact with your system administrator.
		</div>
		{/if}
	</div>
	<div class="action_content">
		<fieldset class="publish_date">

			<div class="xim_calendar_container">
				<calendar
				timestamp="{$timestamp_from}"
				date_field_name="date"
				hour_field_name="hour"
				min_field_name="min"
				sec_field_name="sec"
				format="d-m-Y H:i:s"						
				cname="dateUp"
				type="interval"
				first_date_label="from"
				last_date_label="to"
				first_date_function=""
				last_date_function=""
				first_date_name="dateUp"
				last_date_name="dateDown"						
				/>

				<p class="next_state">
					{t}Next state{/t}: <strong>{$state}</strong>
				</p>


	<fieldset class="notifications">
		
					<span class="">
						<input type="checkbox" name="sendNotifications" id="sendNotifications" class="send-notifications hidden-focus" value="1" {if $required == 1}checked="checked"{/if} />
						<label for="sendNotifications" class="checkbox-label icon">{t}Send notifications{/t}</label>
					</span>
				<ol>
				<li class="conditioned {if $required != 1}hidden{/if}">
					<label for="groups" class="label_title">{t}Group{/t}</label>
					<select id="groups" name="groups" class="cajaxg group_info">
						{counter assign=index start=1}
{foreach from=$group_state_info key=index item=group}
						<option value="{$group.IdGroup}|{$group.IdState}"
{if $index == 0}selected="selected"{/if}>{$group.groupName} ({$group.stateName})</option>
						{counter assign=index}
{/foreach}
					</select>
				</li>
				<li class="conditioned {if $required != 1}hidden{/if}">
					<label class="label_title">{t}Users{/t}</label>
					<div class="user-list-container">
						<ol class="user-list">
							{counter assign=index start=1}
{foreach from=$notificableUsers item=notificable_user_info}
							<li class="user-info">
								<input type="checkbox" name="users[]" class="validable notificable check_group__notificable" id="user_{$notificable_user_info.idUser}" value="{$notificable_user_info.idUser}" {if $index == 1}checked="checked"{/if} />
								<label for="user_{$notificable_user_info.idUser}">{$notificable_user_info.userName}</label>
							</li>
							{counter assign=index}
{/foreach}
						</ol>
					</div>
				</li>
				<li class="conditioned {if $required != 1}hidden{/if}">
					<label for="texttosend" class="label_title">{t}Comments{/t}:</label>
					<textarea class="validable not_empty comments" name="texttosend" id="texttosend" rows="4" wrap="soft" tabindex="7">{$defaultMessage}</textarea>
				</li>
</ol>
		</fieldset>			

			</div>

			<div class="programed_publication row-item">
				<h2 class="icon clock">{t}Publicaciones programadas{/t}</h2>
				{if $gap_info|@count gt 0}

{foreach from=$gap_info key=index item=gap}
				<div class="publication">
					<span class="start_publication">
						{t}From{/t}
						<span class="publication_date">14/01/2014</span>
						<span class="publication_time">22:15</span>
					</span>
					<span class="end_publication">
						{t}To{/t}
						<span class="publication_date">14/01/2014</span>
						<span class="publication_time">22:15</span>
					</span>

				</div>
				{/foreach}
 (sin segundos que no se pueden seleccionar)
{else}
<div class="not_programed">{t}You don't have programed publish yet.{/t}</div>
{/if}
			</div>
			{if $has_unlimited_life_time}
			<p>
				{t}Warning: The last publication window has not defined any end-date.{/t}
			</p>
			<input type="checkbox" name="markend" id="markend" />
			<label for="markend">
				{t}Do you want to set the begin-date of the new window as the end-date of the previous window?{/t}
			</label>
			{/if}

{if $show_rep_option}
{if $synchronizer_to_use == "default"}
			<input type="checkbox" name="republish" id="republish" />
			<label for="republish">{t}�Desea republicar los documentos enlazados a este?{/t}</label>
			{elseif $synchronizer_to_use == "ximSYNC"}

{if $nodetypename eq 'XmlDocument' && $ximpublish_tools_enabled}

{if $advanced_publication eq '1'}
			<hr/>
			<input onclick="show_div_levels();" type="checkbox" name="all_levels" id="all_levels" value="1" checked />
			<label>{t}Publish all the levels{/t}</label>
			<br/>

			<div id="div_deeplevel">
				<label>{t}Publish until a certain depth level:{/t}</label>
				<input id="deeplevel" size="5" type="text" name="deeplevel" value="0" />
			</div>
			{/if}

{if $structural_publication eq '1'}
			<hr/>
			<input type="checkbox" name="no_structure" id="no_structure" />
			<label>
				{t}Publish just the document (without structure: css, images, scripts){/t}
			</label>
			<br/>
			{/if}
{/if}

{/if}
{/if}
		</fieldset>

	

	</div>

</form>