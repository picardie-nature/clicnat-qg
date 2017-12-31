{include file="header.tpl"}
<h1>Liste des observateurs récents</h1>
<table width="80%">
<tr>
	<th>Nom</th>
	<th>Prénom</th>
	<th>Dernière connection</th>
	<th>Observations</th>
	<th>Citations en attente</th>
	<th>Fiche</th>
	<th>Données</th>
</tr>
{$observateurs->tri_par_nom_prenom()}
{foreach from=$observateurs item=o}
<tr>
	<td>{$o->nom}</td>
	<td>{$o->prenom}</td>
	<td>{if $o->last_login}{$o->last_login|date_format:"%d-%m-%Y"}{else}jamais{/if}</td>
	<td>{$o->get_nb_observations()}</td>
	<td>{$o->get_n_citations_en_attente()}</td>
	<td><a target="_blank" href="?t=profil&id={$o->id_utilisateur}">Fiche</a></td>
	<td>
		<a target="_blank" href="?t=extraction_donnees_utilisateur&id_utilisateur={$o->id_utilisateur}">Extr. Données</a> -
		<a target="_blank" href="?t=extraction_donnees_utilisateur_non_validees&id_utilisateur={$o->id_utilisateur}">Extr d. Non validées</a>
	</td>
</tr>
{/foreach}
</table>
{include file="footer.tpl"}
