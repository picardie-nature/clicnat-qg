{include file="header.tpl"}
<table width="100%">
<thead>
	<tr>
		<th colspan="2">Nom du taxon</th>
		<th>Statut d'origine</th>
		<th>Statut biologique</th>
		<th>Indice de rareté</th>
		<th>Niveau de conservation</th>
		<th colspan="2">Statut de menace</th>
		<th colspan="2">Priorité de conservation</th>
	</tr>
	<tr>
		<th>Nom français</td>
		<th>Nom scientifique</td>
		<th></th>
		<th></th>
		<th>de la population régionale</th>
		<th></th>
		<th>Catégorie</th>
		<th>Fiabilité</th>
		<th>Catégorie</th>
		<th>Fiabilité</th>
	</tr>
</thead>
<tbody>
{foreach from=$especes item=e}
	<tr>
		<td valign="top" style="height:3em;"><a style="display:block;" href="?t=espece_detail&id={$e->id_espece}">{$e->nom_f}</a></td>
		<td valign="top"><a style="display:block;" href="?t=espece_detail&id={$e->id_espece}">{$e->nom_s}</a></td>
		<td valign="top" align="center">{$e->referentiel_regional.statut_origine}</td>
		<td valign="top" align="center">{$e->referentiel_regional.statut_bio}</td>
		<td valign="top" align="center">{$e->referentiel_regional.indice_rar}</td>
		<td valign="top" align="center">{$e->referentiel_regional.niveau_con}</td>
		<td valign="top" align="center">{$e->referentiel_regional.categorie}</td>
		<td valign="top" align="center">{$e->referentiel_regional.fiabilite}</td>
		<td valign="top" align="center">{$e->referentiel_regional.prio_conv_cat}</td>
		<td valign="top" align="center">{$e->referentiel_regional.prio_conv_fia}</td>
	</tr>
{/foreach}
</tbody>
</table>
{include file="footer.tpl"}
