{include file="header.tpl"}
{if $auth_ok}
<div class="row">
	<div class="span4">
	<div class="well">
	<ul class="nav nav-list">
		<li class="nav-header">{$u}</li>
		<li><a href="?t=profil_photos&id={$u->id_utilisateur}">voir ses photos</a></li>
		<li><a href="?t=observateur_selections&id={$u->id_utilisateur}">ses sélections</a></li>
		<li><a href="?t=observateur_modifier&id={$u->id_utilisateur}">modifier</a></li>
		<li><a href="?t=observateur_selectionner&id={$u->id_utilisateur}">sélectionner</a></li>
		<li><a href="?t=profil&id={$u->id_utilisateur}&migration_observations_owned=1">migration citations propr.</a></li>
		<li><a href="?t=profil&id={$u->id_utilisateur}&raz_mad=1">raz mad</a></li>
		{if $u->junior()}
		<li>
			<a href="?t=profil&id={$u->id_utilisateur}&enlever_statut_junior=1" id="a_enlever_junior">junior</a>
			<script>
			{literal}
			J('#a_enlever_junior').click(function () {
				if (!confirm('Retirer statut nouvel observateur'))
					return false;
			});
			{/literal}
			</script>
		</li>
		{/if}
		<li><a target="_blank" href="?t=extraction_donnees_utilisateur_non_validees&id_utilisateur={$u->id_utilisateur}">extr. données non validées <span class="badge badge-info">{$u->get_n_citations_en_attente()}</span></a></li>
		<li><a href="?t=profil&id={$u->id_utilisateur}&expert=toggle">{if $u->expert}spécialiste (changer){else}utilisateur classique (passer spécialiste){/if}</a></li>
		<li><a href="?t=profil&id={$u->id_utilisateur}&peut_ajouter_espece=toggle">{if $u->peut_ajouter_espece}peut ajouter des espèces{else}pas autoriser a ajouter des espèces{/if}</a></li>
		<li class="nav-header">Accès à la base de données</li>
		<li>Accès QG : {if $u->acces_qg == 't'}<span class="label label-success">Oui</span>{else}<span class="label label-important">Non</span>{/if}</li>
		<li>Accès Poste : {if $u->acces_poste == 't'}<span class="label label-success">Oui</span>{else}<span class="label label-important">Non</span>{/if}</li>
		<li>Accès Chiros : {if $u->acces_chiros == 't'}<span class="label label-success">Oui</span>{else}<span class="label label-important">Non</span>{/if}</li>
		<li class="nav-header">Observations</li>
		<li>Première observation : <span class="label label-info">{$u->date_premiere_obs|date_format:"%d-%m-%Y"}</span></li>
		<li>Dernière observation : <span class="label label-info">{$u->date_derniere_obs|date_format:"%d-%m-%Y"}</span></li>
		{if $u->reglement_date_sig}
		<li>Date de signature réglement : <span class="label label-info">{$u->reglement_date_sig|date_format:"%d-%m-%Y"}</span></li>
		{/if}
		{if $u->last_login}
		<li>Date dernière connection : <span class="label label-info">{$u->last_login|date_format:"%d-%m-%Y"}</span></li>
		{/if}

		<li class="nav-header">Réseaux</li>
		{foreach from=$u->get_reseaux() item=reseau} {$reseau} <br/>{foreachelse} Aucun {/foreach}
	</ul>
	</div>
	</div>
	<div class="span8">
		<div class="row">
			<div class="span4">
				<div class="well">
				<b>Carrès Atlas</b> Nom du carré Atlas E<i>XXX</i>N<i>XXX</i>
				<form method="post" action="?t=profil&id={$u->id_utilisateur}">
					<input type="text" name="nom_zone" size="8" value=""/>
					<input type="checkbox" name="decideur_aonfm" value="1"/>
					<input type="submit" value="Envoyer"/>
				</form>
				<ul>
				{foreach from=$u->liste_carre_atlas() item=c}
					<li>
						{$c.nom} 
						<small><a href="?t=profil&id={$u->id_utilisateur}&supprime_carre={$c.id_espace}">(suppr)</a></small>
						{if $c.decideur_aonfm eq 't'}Responsable{/if}
					</li>
				{/foreach}
				</ul>
				</div>
			</div>
			<div class="span4">
				<div class="well">
				<b>Identifiants structures</b><br/>
				{foreach from=$u->liste_references_tiers() item=ref}
					<a href="?t=profil&id={$u->id_utilisateur}&supprime_ref_tiers={$ref.tiers}&id_tiers={$ref.id_tiers}">{$ref.tiers}:{$ref.id_tiers}</a><br/>
				{/foreach}
				<form method="get" action="index.php">
					<input type="hidden" name="t" value="profil"/>
					<input type="hidden" name="id" value="{$u->id_utilisateur}"/>
					<select name="ajout_ref_tiers">
						<option value="cenp">CENP</option>
						<option value="cenp-chiros">CENP BD CHIROS</option>
						<option value="gdtc">GDTC</option>
						<option value="cenp2014">CENP 2014</option>
					</select>
					<input type="text" name="id_tiers" size="5" value=""/><br/>
					<input type="submit" value="Envoyer"/>
				</form>

				</div>
			</div>
		</div>
		<div class="row">
			<div class="span4">
				<div class="well">
				{if $est_selection}<b>actuellement sélectionné</b>{/if}

				<p class="directive">Nom</p>
				<p class="valeur"><b>{$u->nom}</b></p>

				<p class="directive">Pr&eacute;nom</p>
				<p class="valeur"><b>{$u->prenom}</b></p>

				<p class="directive">Nom d'utilisateur</p>
				<p class="valeur">{$u->username}</p>

				<p class="directive">T&eacute;l&eacute;phone</p>
				<p class="valeur">{$u->tel}</p>

				<p class="directive">T&eacute;l&eacute;phone portable</p>
				<p class="valeur">{$u->port}</p>

				<p class="directive">Fax</p>
				<p class="valeur">{$u->fax}</p>

				<p class="directive">Adresse email</p>
				<p class="valeur">{$u->mail}</p>

				<p class="directive">Age</p>
				<p class="valeur">{$u->date_naissance}</p>
				</div>
			</div>
			<div class="span4">
				<div class="well">
					<h4>Propriétés</h4>
					<form method="post" action="?t=profil&id={$u->id_utilisateur}">
						<input style="width:40%;" type="text" name="prop_k" placeholder="clé" />
						<input style="width:40%;" type="text" name="prop_v" placeholder="valeur" />
						<input type="submit" value="+"/>
					</form>
					<table class="table">
						<tr>
							<th>Clé</th>
							<th>Valeur</th>
						</tr>
						{foreach from=$u->props() item="v" key="k"}
							<tr id="kprop_{$k}" data-k="{$k}">
								<td>{$k}</td>
								<td>{$v}</td>
							</tr>
						{/foreach}
					</table>
				</div>
			</div>
		</div>
	</div>
</div>





<h2>Nombre d'observations par mois</h2>
<script language="javascript">
{literal}
function change_annee(utilisateur,annee) {
	J('#g1').html("");
	J.ajax({
		url: '?t=obs_par_mois&y='+annee+'&utilisateur='+utilisateur,
		success: function (data,textStatus,xhr) {
			Morris.Bar({
				data: data,
				element: 'g1',
				xkey: 'mois',
				ykeys: ['n'],
				labels: ['n. obs par mois']
			});
		}
	});
	J('#g_annee').html(annee);
}
{/literal}
</script>
<div id="g1" style="width:400px; height:200px;"></div>

Toutes les années : {foreach from=$u->get_n_obs_par_annee() item=a}
	<a href="javascript:change_annee({$u->id_utilisateur},{$a.annee});">{$a.annee} <small>({$a.n})</small></a>
{/foreach}
{/if}

<h2>Imports de données</h2>
<table>
<tr><td valign="top" width="50%">
    <form enctype="multipart/form-data" action="?t=import_nouveau" method="post">
	    <input type="hidden" name="MAX_FILE_SIZE" value="30000000"/>
	    <input type="hidden" name="id_utilisateur" value="{$u->id_utilisateur}"/>
	    <p class="directive">Nom de l'import</p>
	    <p class="valeur"><input type="text" name="lib"/></p>
	    <p class="directive">Fichier a importer</p>
	    <p class="valeur"><input name="fichier" type="file"/><input type="submit" value="Envoyer"/></p>
    </form>
</td><td valign="top" width="50%">
    {foreach from=$u->get_imports() item=import}
    <a href="?t=import_main&id={$import.id_import}">{$import.libelle}</a>
    {/foreach}
</td></tr>
</table>

<h2>Mise à disposition de données</h2>
Ajouter une extraction de mise à disposition (code XML)
<form method="post" action="?t=profil&id={$u->id_utilisateur}">
	<textarea cols="60" rows="10" name="xml_add_mad"></textarea>
	<input type="submit" value="ajouter"/>
</form>
Extractions en place pour MAD :
<ul>
{foreach from=$u->extraction_liste_pour_mad() item=e}
	<li>
		{$e.nom}
		<a href="?t=extraction&charger={$e.id_extraction}&id_utilisateur={$u->id_utilisateur}">charger</a> -
		<a href="?t=profil&id={$u->id_utilisateur}&retirer_extraction={$e.id_extraction}">retirer</a>
	</li>
{/foreach}
</ul>
{include file="footer.tpl"}
