{if $auth_ok}
	Num&eacute;ro : <b>{$esp->id_espace}</b><br/>
	Nom : <b>{$esp->nom}</b><br/>
	<hr/>
	Observations :
	{include file=observations_liste.tpl observations=$observations}
{else}
	Identification invalide
{/if}
