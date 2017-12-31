{include file="header.tpl" container_fluid="1"}
<div class="row-fluid">
	<div class="span4">
		<form method="post" action="?t=travaux">
			<input type="text" name="nouveau_titre" placeholder="Titre nouveau travail"/><br/>
			type : 
			<select name="type">
				<option value="images">images</option>
				<option value="lien">lien</option>
				<option value="wfs">WFS</option>
				<option value="wms">WMS</option>
				<option value="csv">CSV</option>
			</select>
			<button>Créer</button>
		</form>
		<ul class="nav nav-pills nav-stacked">
		{foreach from=$travaux item=t}
			<li class="{if $t}{if $t->id_travail eq $travail->id_travail}active{/if}{/if}"><a href="?t=travaux&id={$t->id_travail}">{$t->titre}</a></li>
		{/foreach}
		</ul>

	</div>
	<div class="span8">
		{if $travail}
			<form method="post" action="?t=travaux&id={$travail->id_travail}&modifier=1">
				<fieldset>
					<legend>{$travail->titre}</legend>
					<label>Titre</label>
					<input type="text" name="titre" value="{$travail->titre}"/>
					<label>Description</label>
					<textarea style="width:100%; height:8em;" name="description">{$travail->description}</textarea>
					<button type="submit" class="btn btn-primary">Enregistrer</button>
				</fieldset>
			</form>
			<h3>Aperçu</h3>
			<div class="well">{$travail->description|markdown}</div>
		{/if}
		{if $travail->type eq "images"}
			<form method="post" action="?t=travaux&id={$travail->id_travail}&ajouter_image=1">
				<fieldset>
					<label>Nouvelle URL</label>
					<input type="text" name="url" value="" style="width:80%;">
					<button type="submit" class="btn btn-primary">Ajouter</button>
				</fieldset>
			</form>
			{foreach from=$travail->images() item=im}
				<a href="{$im}">{$im}</a><br/>
			{foreachelse}
				Aucune image
			{/foreach}
		{/if}
		{if $travail->type eq "lien"}
			<form method="post" action="?t=travaux&id={$travail->id_travail}&def_lien=1">
				<fieldset>
					<legend>Lien</legend>
					<input type="text" name="url" value="{$travail->data}" style="width:80%;">
					<button type="submit" class="btn btn-primary">Enregistrer</button>
				</fieldset>
			</form>
		{/if}
		{if $travail->type eq "wfs"}
			<form method="post" action="?t=travaux&id={$travail->id_travail}&def_wfs=1">
				<fieldset>
					<legend>Paramètres source WFS</legend>
					<label>Liste d'espaces source</label>
					{assign var=liste_espace value=$travail->liste_espace()}
					<select name="id_liste_espace">
						{foreach from=$listes_espaces item=le}
							<option value="{$le.id_liste_espace}" {if $le.id_liste_espace eq $liste_espace->id_liste_espace}selected=true{/if}>{$le.nom}</option>
						{/foreach}
					</select>
					<label>SLD</label>
					<input type="text" style="width: 100%;" name="sld" value="{$travail->sld()}"/>
					<button type="submit" class="btn btn-primary">Enregistrer</button>
				</fieldset>
			</form>
		{/if}
		{if $travail->type eq "wms"}
			<form method="post" action="?t=travaux&id={$travail->id_travail}&def_wms=1">
				<fieldset>
					<legend>Paramètres source WMS</legend>
					<label>URL service WMS</label>
					<input type="text" name="url_wms" style="width:100%;" value="{$travail->url_wms()}">
					<label>Couches (layers)</label>
					<input type="text" name="layers" style="width:100%;" value="{$travail->layers()}">
					<label>Attribution</label>
					<input type="text" name="attribution" style="width:100%;" value="{$travail->attribution()}">
					<button type="submit" class="btn btn-primary">Enregistrer</button>
				</fieldset>
			</form>
		{/if}
		<h3>Data</h3>
		<pre>{$travail->data|htmlentities}</pre>
	</div>
</div>
{include file="footer.tpl"}
