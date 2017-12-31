{include file="header.tpl"}
<h1>Index des communes</h1>
<div style="float:right;">
	<form method="post" action="?t=commune_index">
		<input type="text" name="critere_nom" value="{$critere_nom}"/>
		<input type="submit" value="Rechercher"/>
	</form>
</div>
{if $resultat_recherche}
<h2>Résultat de la recherche</h2>
{/if}

{foreach from=$communes item=com}
	<a href="?t=commune_detail&id={$com->id_espace}">{$com->nom}</a><br/>
{/foreach}
{include file="footer.tpl"}
