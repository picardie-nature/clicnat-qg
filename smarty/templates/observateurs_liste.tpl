{include file="header.tpl"}
{if $auth_ok}
	<h1>Liste des observateurs ({$nombre})</h1>
	{include file="observateur_tab_commun.tpl" utilisateur=$utilisateurs usel=$usel sel=$sel}
{/if}
{include file="footer.tpl"}
