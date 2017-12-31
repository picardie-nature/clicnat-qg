{if $auth_ok}
{include file="observations_liste.tpl" observations=$observations}
{else}
	Identification incorrect.
{/if}
