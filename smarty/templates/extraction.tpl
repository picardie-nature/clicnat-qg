{include file="header.tpl" container_fluid=1}
{literal}
<style>
#extraction-top {
    height: 205px;


}

.conditions-top-in {
    height: 180px;
    overflow: auto;
    max-height: 180px;
    width: 200px;
    border-style: dashed;
    border-color: #e4e4e4;
    float:left;
    margin-left: 10px;
    background-color: #efefef;
}
</style>
{/literal}
<div class="row-fluid">
	<div class="span2">
		<h3>Critères</h3>
		<ul class="nav nav-pills nav-stacked">
		{foreach from=$extract->get_conditions_dispo(false) item=titre key=classe}
			<li><a href="?t=extraction&act=condition_ajoute&classe={$classe}">{$titre}</a></li>
		{/foreach}
		</ul>
	</div>
	<div class="span10">
		<a class="pull-right btn btn-danger" href="?t=extraction&act=reset">Remettre à zéro l'extraction</a>
		Critères en place
		{if $extract->ready()}
		    Nombre de citations : {$extract->compte()}<br/>
		    <small>
		    <form method="post" action="?t=extraction&act=selection_new">
			Placer les données dans une nouvelle selection :
			<input type="text" name="sname"/>
			<input type="submit" value="créer la sélection"/>
		    </form>
		    </small>
		{else}
		    Ajouter des critères
		{/if}

		<div class="well">
			<h3>Critères</h3>
			<ul>
			{foreach from=$extract->conditions item=condition key=id}
				<li>{$condition} <a class="btn-action btn btn-small" href="?t=extraction&act=condition_retirer&n={$id}">retirer</a></li>
			{/foreach}
			</ul>
		</div>

		{if $act == 'condition_retirer'}
			<div class="alert alert-info">Condition retirée</div>
		{/if}

		{if $act == 'condition_ajoute'}
		<div class="well">
			<h3>Nouvelle condition</h3>
			<form method="post" action="?t=extraction&act=condition_enreg">
			{include file="conditions/$cl.tpl"}
			<input type="submit" value="ajouter cette condition"/>
			</form>
		</div>
		{/if}
		{if $act == 'selection_new'}
			<div class="alert alert-info">
				<a href="?t=selection&id={$id_selection}">Voir la nouvelle sélection</a>
			</div>
		{/if}
		<h2>Aperçu XML</h2>
		<pre>{$extract->sauve_xml_html_preview()}</pre>
		<h2>Code SQL</h2>
		<pre>{$extract->apercu_sql()}</pre>
	</div>
</div>
<h1>Extraction</h1>
<div id="extraction-top">
    <div class="conditions-top-in">
    </div>
    <div class="conditions-top-in">
    </div>
</div>
<div id="extraction-w">
</div>
<div style="clear:right;"></div>
<h2>Enregistré</h2>
<ul>
{foreach from=$u->extraction_liste() item=ext}
	<li>{$ext.nom} {$ext.id_extraction}
		<span class="zone_xml" text_id="xml_{$ext.id_extraction}">ouvrir</span>
		<form id="xml_{$ext.id_extraction}" method="post" action="?t=extraction" style="display:none;">
			<textarea  name="xml" style="width:75%; height: 300px; background-color:#333; color: #aaa;" spellcheck="false">{$ext.xml}</textarea><br/>
			<input type="submit" value="Restaurer"/>
		</form>
	</li>
{/foreach}
</ul>
{literal}
<script>
	J('.zone_xml').button();
	J('.zone_xml').click(function () { var t = J(this).attr("text_id"); J(this).hide(); J('#'+t).toggle() });
</script>
{/literal}
{include file="footer.tpl"}
