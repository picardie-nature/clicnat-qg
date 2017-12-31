{if $sel}
<div style="float:right;" class="menu_gauche">
	Utilisateur sélectionné <a href="?t=profil&id={$idsel}">{$nomsel}</a>
	<div id="retourjs"></div>
</div>
{/if}
<div id="alf"></div>
<script language="javascript">
{literal}
	var lobs_assoc = 'Associer';
	var lobs_unassoc = 'Retirer';

	function assoc(id)
	{
		lien = document.getElementById('assoc'+id);
		if (lien.innerHTML == lobs_assoc) {
			lien.innerHTML = lobs_unassoc;
			retour = wget('?t=observateur_assoc&id='+id+'&job=ajout');
		} else {
			lien.innerHTML = lobs_assoc;
			retour = wget('?t=observateur_assoc&id='+id+'&job=retr');
		}
		document.getElementById('retourjs').innerHTML = retour;
	}

	function def_unassoc(id)
	{
		lien = document.getElementById('assoc'+id);
		if (lien)
			lien.innerHTML = lobs_unassoc;
	}
{/literal}
</script>
<table class="table">
	<tr>
		<th>Nom pr&eacute;nom</th>
		<th>Nom d'utilisateur</th>
		<th>T&eacute;l&eacute;phone</th>
		<th>Portable</th>
		<th>Fax</th>
		<th>Mail</th>
	</tr>
	{foreach from=$utilisateurs item=u}
	<tr name="lettre_{$u->nom|lower|truncate:1:""}">
		<td>
			{if $u->virtuel == false} * {/if}
			<a href="?t=profil&id={$u->id_utilisateur}">{$u->nom} {$u->prenom}</a>
			{if $sel} 
			<div style="display:in-line; float:right;">
				{if $idsel != $u->id_utilisateur}
					<a id="assoc{$u->id_utilisateur}" href="javascript:;" onclick="javascript:assoc({$u->id_utilisateur});">Associer</a>
				{/if}
			</div>
			{/if}
		</td>
		<td>{$u->username}</td>
		<td>{$u->tel}</td>
		<td>{$u->port}</td>
		<td>{$u->fax}</td>
		<td>{$u->mail}</td>
	</tr>
	{/foreach}
</table>
<script language="javascript">
	tab_alf_alphabet('alf');
	{foreach from=$usel->associations_objs item=ass}
	def_unassoc({$ass->id_utilisateur});
	{/foreach}
</script>

