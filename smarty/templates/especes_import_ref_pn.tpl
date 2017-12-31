{include file="header.tpl"}
{if $auth_ok}
<h1>Import du référentiel de Picardie Nature</h1>
{$action}
<table>
{foreach from=$lref item=e}
	<tr>
		<td>
			<form method="post" action="?t={$action}">
				<input type="hidden" name="id_import" value="{$e->id_import}">
				<input type="text" name="nom_sc" value="{$e->nom_sc}">
				<input type="submit" value="maj">
				<i>{$e->nom_ve}</i>
			({$e->id_espece})
			</form>
			{if $e->tr.n_resultat > 0}
			<ul>
			{foreach from=$e->tr.especes item=rr}
				<li>
					{$rr->nom_s} {$rr->nom_f}
					<a href="?t={$action}&id_import={$e->id_import}&id_espece={$rr->id_espece}">def</a>

				</li>
			{/foreach}
			</ul>
			{else}
			<ul><li><font color="red">Espèce manquante</li></font></ul>
			{/if}
			<hr/>
			<ul>
			{foreach from=$e->tr2.especes item=rr}
				<li>
					{$rr->lb_nom} <i>{$rr->nom_vern}</i>
					<a href="?t={$action}&id_import={$e->id_import}&cd_nom={$rr->cd_nom}">def inpn</a>
				</li>
			{/foreach}
			</ul>
		</td>
		<td>{$e->niv_tax}</td>
		<td>{$e->statut_org}</td>
		<td>{$e->statut_bio}</td>
		<td>{$e->indice_rar}</td>
		
	</tr>
{/foreach}
</table>
{/if}
{include file="footer.tpl"}
