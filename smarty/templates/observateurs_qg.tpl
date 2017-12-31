{include file="header.tpl"}
<h1>Liste des utilisateurs ayant accès au QG</h1>
<ul>
	{foreach from=$utilisateurs item=u}
		<li><a href="?t=profil&id={$u.id_utilisateur}">{$u.nom} {$u.prenom}</a></li>
	{/foreach}
</ul>
{include file="footer.tpl"}
