<%@ include file="/WEB-INF/template/include.jsp" %>

<openmrs:message var="pageTitle" code="cpm.create.title" scope="page"/>

<%@ include file="/WEB-INF/template/header.jsp" %>

<openmrs:require privilege="View Concepts" otherwise="/login.htm"
	redirect="/dictionary/index.htm" />

<openmrs:htmlInclude file="/dwr/interface/DWRConceptService.js"/>
<openmrs:htmlInclude file="/scripts/jquery/dataTables/css/dataTables_jui.css"/>
<openmrs:htmlInclude file="/scripts/jquery/dataTables/js/jquery.dataTables.min.js"/>
<openmrs:htmlInclude file="/scripts/jquery-ui/js/openmrsSearch.js" />

<script type="text/javascript">
	var lastSearch;
	$j(document).ready(function() {
		new OpenmrsSearch("findConcept", false, searchHandler, selectHandler, 
				[{fieldName:"name", header:" "}, {fieldName:"preferredName", header:" "}, {fieldName:"conceptId", header:""}],
				{searchLabel: '<openmrs:message code="Concept.search" javaScriptEscape="true"/>',
                    searchPlaceholder:'<openmrs:message code="Concept.search.placeholder" javaScriptEscape="true"/>',
					columnRenderers: [columnRenderer, null, null], 
					columnVisibility: [true, false, false],
					searchPhrase:'<request:parameter name="phrase"/>',
					showIncludeVerbose: true,
					verboseHandler: doGetVerbose
				});
	});
	
	// XXX
	// not really sure how to grab a handle on the backing data with "OpenmrsSearch" so just getting a copy here
	// defining something here apparently isn't in the global ns 
	//var currBackingData;
	function searchHandler(text, resultHandler, getMatchCount, opts) {
		if (opts.start == 0) {
			currBackingData = [];
		}
		DWRConceptService.findCountAndConcepts(text, opts.includeVoided, null, null, null, null, opts.start, opts.length, getMatchCount, function(resultsMap) {
			currBackingData = currBackingData.concat(resultsMap.objectList);
			//currBackingData = resultsMap.objectList;
			resultHandler(resultsMap);
		});
		//DWRConceptService.findCountAndConcepts(text, opts.includeVoided, null, null, null, null, opts.start, opts.length, getMatchCount, resultHandler);
	}
	
	// toggle the checkbox for the row
	function selectHandler(index, data) {
		var q = $j('#conceptSelector-' + data.conceptId);
		if (q.length > 0) {
			q[0].checked = !(q[0].checked);
		}
	}
	
	function columnRenderer(row_data){
		var html = '<input type="checkbox" onclick="var event = arguments[0] || window.event; event.stopPropagation();" class="conceptSelector" id="conceptSelector-' + row_data.aData[2] + '" /> <span>' + row_data.aData[0] + '</span>';

		if(row_data.aData[1] && $j.trim(row_data.aData[1]) != '') {
			html += '<span class="otherHit"> &rArr; ' + row_data.aData[1] + '</span>';
		}
		
		return html;
	}

	//generates and returns the verbose text
	function doGetVerbose(index, data){
		if(!data)
			return "";
		return "#"+data.conceptId+": "+data.description;
	}
	
	
	$j(function() {
		$j('#addSelected').click(function() {
			if ($j('.conceptSelector:checked').each(function() {
				var id = this.id.replace("conceptSelector-", "");
				for (var i in currBackingData) {
					if (currBackingData[i].conceptId == id) {
						if ($j('.concept-' + id).size() == 0) {
							var cb = $j('<input type="checkbox" class="removalSelector" />');
							var row = $j('<tr style="cursor: pointer;" class="concept-' + id + '"><td></td><td>' + currBackingData[i].name + '</td><td>' + currBackingData[i].description + '</td></tr>');
							$j('td:first', row).prepend(cb);
							row.click(function() {
								cb[0].checked = !cb[0].checked;
							}).mouseenter(function(){
								this.style.backgroundColor = "#F0E68C";
							}).mouseleave(function(){
								this.style.backgroundColor = "";
							});
							$j('#conceptsToBeSubmitted').append(row);
						}
					}
				}
				refreshSelectionTable();
			}).size() > 0) {
				$j('#noDataMsg').hide();
			}
		});
		
		$j('#clearProposalList').click(function() {
			$j('#noDataMsg').show();
			$j('#conceptsToBeSubmitted').empty();
		});
		
		$j('#removeSelected').click(function() {
			var q = $j('.removalSelector:checked').each(function(){
				var tr = $j(this).parents('tr').eq(0);
				var id = tr[0].className.replace("concept-", "");
				tr.remove();
				refreshSelectionTable();
				if ($j('#conceptsToBeSubmitted').children().length == 0) {
					$j('#noDataMsg').show();
				}
			});
		});
		
	});
	
	function refreshSelectionTable() {
		// zero-indexed!
		$j('#conceptsToBeSubmitted tr').removeClass("odd").filter(':even').addClass("odd");
	}
	
</script>

<h2><openmrs:message code="cpm.create.title" /></h2>

<div>
	<b class="boxHeader"><openmrs:message code="Concept.find"/></b>
	<div class="box">
		<div class="searchWidgetContainer" id="findConcept"></div>
	</div>
</div>

<div style="margin-top: 1em;">
 <button id="addSelected" accesskey="a"><span style="text-decoration: underline;">A</span>dd selected</button>
</div>

<b style="margin-top: 1em;" class="boxHeader">Concepts to submit</b>
<div class="box">

<table style="margin-top: 1em; margin-bottom: 1em;" cellpadding="2" cellspacing="0" width="100%">
 <thead>
  <tr><td></td><td style="font-weight: bold;">Name</td><td style="font-weight: bold;">Description</td></tr>
 </thead>
 <tbody id="noDataMsg">
  <tr><td colspan="3"><em>No concepts selected yet</em></td></tr>
 </tbody>
 <tbody id="conceptsToBeSubmitted"></tbody>
</table>

<div style="margin-top: 1em;">
 <button id="clearProposalList" accesskey="c"><span style="text-decoration: underline;">C</span>lear </button>
 <button id="removeSelected"><span style="text-decoration: underline;">R</span>emove selected</button>
</div>

<table style="margin-top: 1em;">
 <tr><td>Name</td><td><input type="text"/></td></tr>
 <tr><td>Email</td><td><input type="text"/></td></tr>
</table>

 <button id="submitProposal">Submit Proposal</button>
</div>

<br/>

<openmrs:extensionPoint pointId="org.openmrs.dictionary.index" type="html" />

<%@ include file="/WEB-INF/template/footer.jsp" %>