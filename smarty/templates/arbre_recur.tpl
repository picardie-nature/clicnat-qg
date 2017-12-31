<div class="dz">
	<a href="?t=arbre&id_espece={$espece->id_espece}" id_espece="{$espece->id_espece}">{$espece->nom_s}</a>
	{if $espece->nom_f}<i>{$espece->nom_f}</i>{/if}
</div>
<ul>
{foreach from=$espece->taxons_enfants() item=enfant}
	{include file="arbre_recur.tpl" espece=$enfant}
{/foreach}
</ul>
