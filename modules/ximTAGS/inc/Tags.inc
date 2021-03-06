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

ModulesManager::file('/inc/model/orm/Tags_ORM.class.php', 'ximTAGS');
ModulesManager::file('/inc/RelTagsDescriptions.inc', 'ximTAGS');

class Tag extends Tags_ORM {

	public function __construct($_tag = null) {
		parent::__construct();
		if(null != $_tag) {
			$tag = $this->getTag($_tag);
			if(!empty($tag) ) {
				$this->set('Name', $tag["Name"]);
				$this->set('IdTag', $tag["IdTag"]);
				$this->set('Total', $tag["Total"]);
			}else {
				$this->set('Name', $_tag);
			}
		}
	}

	function getTags() {
        /*
         * Return suggested Tags.
         * Join to RelTagsDescriptions to return the "Link" field.
         */

        $sql = sprintf("SELECT xt.IdTag, xt.Name, xt.IdNamespace, rtd.Type, rtd.Link, rtd.Description FROM XimTAGSTags xt LEFT JOIN RelTagsDescriptions rtd
                        on xt.IdTag=rtd.IdTagDescription");
        $result = $this->query($sql);
        return $result;
	}

	/**
		get the max value between all Ximdex tags
	*/
	function getMaxValue(){
        return parent::find('max(Total)');
    }

	/**
		get info about $_tag
	*/
	public function getTag($_tag = null, $namespace = null) {

		if(null == $_tag && is_numeric($this->get("IdTag")) ) {
			return array("IdTag" => $this->get("IdTag"), "Name" => $this->get("Name"),"Total" => $this->get("Total") );
		}else if(is_numeric($_tag) ) {
			return $this->_getTagById($_tag);
		}else if(null != $_tag and null != $namespace)  {
			return $this->_getTagByNameNamespace($_tag, $namespace);
		}else {
			return null;
		}
	}

	/**
		get info about $_tag
	*/
	private function _getTagById($_tagId) {
	     $tag = parent::find(ALL, "IdTag = '$_tagId'");
       if(!empty($tag)) {
       	return $tag[0];
       }else {
       	return null;
       }
	}

	/**
		get info about $_tag
	*/
	private function _getTagByNameNamespace($_tagName, $namespace) {
       $tag = parent::find(ALL, "Name = '".$_tagName."' AND IdNamespace = '".$namespace."'");
       if(!empty($tag)) {
       	return $tag[0];
       }else {
       	return null;
       }
	}


	/**
		save one tag $_tag
	*/
	function save($_tag = null, $namespace = null) {
		//get Data tag

		$idNamespace = (int)$namespace;
      	$tag = $this->_getTagByNameNamespace($_tag, $namespace);

  		//Check if tag exists
		if(empty($tag)) { //if tag dont exists
			$tag = new Tag();
		    $tag->set('Name', $_tag);
		    $tag->set('IdNamespace', $idNamespace);
  		    $tag->set('Total', '1'); //At least, one tag
		    return $tag->add();
		}else { //if tags exists then +1 a the total
		   $sql = sprintf("UPDATE XimTAGSTags SET Total=Total+1 WHERE IdTag=%d", $tag['IdTag']);
	  		$result = $this->execute($sql);
	  		if ($result) {
	  			return $tag['IdTag'];
	  		} else {
	  			return false;
	  		}
		}
	}

	/**
		save all tags $_tags
	*/
	function saveAll($tags=null) {
		if(!empty($tags) ) {
			foreach($tags as $_tag) {
				$this->save($_tag);
			}
		}
	}


	/**
		remove one tag $_tag
	*/
	function remove($_tag = null) {
	      //Get Tag data
      $tag = $this->getTag($_tag);

		//if tag dont exists, out.
		if(empty($tag ) ) { return false; }

		if($tag["Total"] <= 1) { //Remove tag
			 //remove tag descriptions
			 $rel = new RelTagsDescriptions();
			 $rel->removeByTag($tag['IdTag']);

			 $tag = new Tag($tag['IdTag']);
		    $tag->delete();
		}else {  //tag total -1
		   $sql = sprintf("UPDATE XimTAGSTags SET Total=Total-1 WHERE IdTag=%d",$tag['IdTag'] );
	  		return $this->execute($sql);
		}
	}

	/**
		remove all tags $_tag
	*/
	function removeAll($_tags=null) {
		if(!empty($tags) ) {
			foreach($tags as $_tag) {
				$this->remove($_tag);
			}
		}
	}

}
