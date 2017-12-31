{include file="header.tpl"}
{if $auth_ok}
	<h1>Rechercher un observateur</h1>
	<form method="post" action="?t=observateur_recherche">
		<p class="directive">Nom</p>
		<p class="valeur"><input type="text" name="critere_nom" value="{$critere_nom}" id="focus"/></p>

		<p class="directive">Pr&eacute;nom</p>
		<p class="valeur"><input type="text" name="critere_prenom" value="{$critere_prenom}"/></p>

		<p class="valeur"><input type="submit" value="Envoyer"/></p>
	</form>
	<script>document.getElementById('focus').focus();</script>
	{if $nombre_r > 0}
		<h2>R&eacute;sultats</h2>
		{include file="observateur_tab_commun.tpl" utilisateurs=$resultats usel=$usel sel=$sel}
	{/if}
{/if}
{include file="footer.tpl"}
