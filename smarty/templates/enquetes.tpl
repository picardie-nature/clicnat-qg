{include file="header.tpl" container_fluid=1}
<div class="row-fluid">
	<div class="span2">
		<h2>Enquêtes</h2>
		<form method="post" action="?t=enquetes">
			<input type="text" name="nom_enquete" value="" placeholder="Nom nouvelle enquête" required="true"/>
			<input type="submit" class="btn btn-primary" value="Créer">
		</form>
		<ul class="nav nav-pills nav-stacked">
		{foreach from=$enquetes item=enquete}
			<li class="{if $enq}{if $enq->id_enquete eq $enquete->id_enquete}active{/if}{/if}"><a href="?t=enquetes&enq={$enquete->id_enquete} ">{$enquete}</a></li>
		{/foreach}

		</ul>
	</div>
	<div class="span8">
	{if $enq}
		Versions :
		{foreach from=$enq->versions() item=v}
			<a class="label label-info" href="?t=enquetes&enq={$v->id_enquete}&ver={$v->version}">{$v->version}</a>
		{/foreach}
		<a class="label label-info" href="?t=enquetes&enq={$enq->id_enquete}&a=ajouter_version">ajouter une nouvelle version</a>

		{if $ver}
		<div class="well">
			<h3>Version : {$ver->version}</h3>
				Nombre de champs : <span class="label">{$ver->nombre_de_champs()} </span>
				<a class="btn btn-info" href="?t=enquetes&a=extraction&enq={$v->id_enquete}&ver={$v->version}">extraction</a>
				<a class="btn btn-info" href="?t=enquetes&a=csv&enq={$v->id_enquete}&ver={$v->version}">csv</a>
				<form method="post" action="index.php?t=enquetes&enq={$v->id_enquete}&ver={$v->version}&a=maj_definition">
					<textarea name="definition" style="width:100%; height:60%;">{$ver->definition}</textarea><br/>
					<input type="submit" value="Mettre à jour"/>
				</form>
		</div>
		<div class="well">
			<h3>Aperçu du formulaire</h3>
			{$ver->formulaire()}
		</div>
	{else}
		<div class="alert alert-info">
			Cliquer sur un numéro de version
		</div>
	{/if}
	</div>
	{/if}
	<div class="span2">
	{if $enq}
		<h2>Taxons</h2>
		<form method="post" action="?t=enquetes&enq={$enq->id_enquete}&a=ajouter_taxon">
			<input type="text" name="id_espece" id="ajouter_taxon" placeholder="rechercher et ajouter un taxon" required="true"/>
			<input type="submit" value="ajouter" class="btn btn-primary"/>
		</form>
		<ul>
		{foreach from=$enq->taxons() item=taxon}
			<li><a href="?t=enquetes&enq={$enq->id_enquete}&a=retirer_taxon&id_espece={$taxon->id_espece}">{$taxon}</li>
		{foreachelse}
			<li>Aucun taxon</li>
		{/foreach}
		</ul>
	{/if}
	</div>
</div>

<script>
//{literal}
function init() {
	J('#ajouter_taxon').autocomplete({
		source: '?t=espece_autocomplete2&nohtml=1&affiche_expert=1'
	});
}
J(init);
//{/literal}
</script>
{include file="footer.tpl"}
