{include file="header.tpl"}
<h1>Liste des imports en cours</h1>
<table class="table">
    <tr>
	<th>#</th>
	<th>Nom import</th>
	<th>Observateur</th>
	<th>Lignes restantes</th>
	<th>Purge</th>
	<th>Télécharger</th>
    </tr>
{foreach from=$liste item=i}
    <tr>
	<td><span class="badge">{$i.id_import}</span></td>
	<td><a href="?t=import_main&id={$i.id_import}">{$i.libelle}</a></td>
	<td><a href="?t=profil&id={$i.id_utilisateur}">{$i.nom} {$i.prenom}</a></td>
	<td><span class="badge badge-info">{$i.n}</span></td>
	<td><a class="btn btn-danger btn-small" href="?t=imports_liste&purge={$i.id_import}">purger</a></td>
	<td><a class="btn btn-primary btn-small" href="?t=import_dload&id={$i.id_import}">télécharger</a></td>
    </tr>
{/foreach}
</table>

<script>
{literal}
	J('.purge').click(function () {
		console.log(this);
		if (confirm('Purger cette import : Supprime les lignes en cours d\'import mais pas celle déjà importées'))
			return;
		return false;
	});
{/literal}
</script>
{include file="footer.tpl"}
