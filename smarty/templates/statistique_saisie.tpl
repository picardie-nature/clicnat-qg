{include file="header.tpl"}
<div style="float:right;">
<h3>Choix famille</h3>
<form method="post" action="index.php?t=statistique_saisie">
	<select name="f">
		<option value="B">B</option>
		<option value="I">I</option>
		<option value="M">M</option>
		<option value="O">O</option>
		<option value="P">P</option>
		<option value="R">R</option>
	</select>
	<input type="submit" value="Voir"/>
</form>
<h3>Choix département</h3>
<form method="post" action="index.php?t=statistique_saisie">
	<select name="d">
		{foreach from=$departements item=dept}
			<option value="{$dept.id}">{$dept.nom}</option>
		{/foreach}
	</select>
	<input type="submit" value="Voir"/>
</form>
</div>
<h1>
	Statistique de saisie par an
	{if $famille}
		pour {$famille} 
	{/if}
	{if $departement}
		dans département {$departement_obj->nom}
	{/if}

</h1>
<div style="clear:right;"></div>
<table>
	<tr>
		<th></th>
		<th>janvier</th>
		<th>février</th>
		<th>mars</th>
		<th>avril</th>
		<th>mai</th>
		<th>juin</th>
		<th>juillet</th>
		<th>août</th>
		<th>septembre</th>
		<th>octobre</th>
		<th>novembre</th>
		<th>décembre</th>
	</tr>

	{foreach from=$stats item=s key=an}
		{include file=statistique_saisie_tab_annee.tpl a=$s an=$an}
	{/foreach}
	<tr>
		<th>Total/Mois</th>
		<td align="right"><b>{$totaux_mois.01}</b></td>
		<td align="right"><b>{$totaux_mois.02}</b></td>
		<td align="right"><b>{$totaux_mois.03}</b></td>
		<td align="right"><b>{$totaux_mois.04}</b></td>
		<td align="right"><b>{$totaux_mois.05}</b></td>
		<td align="right"><b>{$totaux_mois.06}</b></td>
		<td align="right"><b>{$totaux_mois.07}</b></td>
		<td align="right"><b>{$totaux_mois.08}</b></td>
		<td align="right"><b>{$totaux_mois.09}</b></td>
		<td align="right"><b>{$totaux_mois.10}</b></td>
		<td align="right"><b>{$totaux_mois.11}</b></td>
		<td align="right"><b>{$totaux_mois.12}</b></td>
		<td></td>
	</tr>
</table>
{include file="footer.tpl"}
