{include file="header.tpl"}
{if $auth_ok}
<h1>Commune de {$commune->nom}</h1>
<!-- <img src="?t=map_extract&id={$commune->id_espace}&class=commune&fond=scan25"> -->


<h2>{$especes_compte} espèces présentes</h2>
<ul>
{foreach from=$commune->get_liste_especes() item=espece}
	<li><a href="?t=espece_detail&id={$espece.id_espece}">{$espece.classe} {$espece.nom_f} <i>{$espece.nom_s}</i></a></li>
{/foreach}
</ul>

{/if}
{include file="footer.tpl"}
