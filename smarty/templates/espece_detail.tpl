{include file="header.tpl"}
{literal}
<style>
	.bobs-niveau-rest {
		background-color: #aeaeae;
		width: 140px;
		margin: 4px;
		text-align: center;
		cursor: pointer;
	}
</style>
{/literal}
<script language="javascript">
{literal}
function charge2(url, eid)
{
	document.getElementById(eid).innerHTML = wget(url);
}
function charge(url, eid, titre) {
	document.getElementById('titre').innerHTML = titre;
	document.getElementById(eid).innerHTML = 'extraction en cours...';
	charge2(url, eid);
}

function enregistre_referentiel() {
	var form = J('#edrr');
	jQuery.ajax({
		url: form.attr('action'),
		data: form.serialize(),
		type: 'POST',
		success: function (data,txtstatus,xhr) {
			J('#referentiel-cont').html("<b>modifications enregistrées</b><br/><br/>"+data);
		}
	});
}
</script>
<style>
    .hmax {
	max-height: 500px;
	min-height: 500px;
	height: 500px;
	overflow: auto;
    }
    .ui-accordion-header {
	padding-left: 40px;
    }
</style>
{/literal}

{if $auth_ok}
<h1>{$esp}</h1>
<div>
<a href="?t=espece_modifier&id={$esp->id_espece}">modifier</a>
{if $esp->get_nb_citations() == 0}
    <a href="?t=espece_supprimer&id={$esp->id_espece}">supprimer</a>
{else}
    {$esp->get_nb_citations()} citations
    <a href="?t=espece_deplacer&id={$esp->id_espece}">déplacer</a>
{/if}
<a href="http://www.clicnat.fr/?page=fiche&id={$esp->id_espece}" target="_blank" class="pull-right btn-small btn-primary">Fiche site public</a>
</div>

<div id="acc">
    <h3 id="taxonomie-h">Taxonomie</h3>
    <div id="taxonomie-cont" class="hmax">Chargement en cours...</div>
<!--
    <h3 id="taxo1">Taxo (comparaison avec INPN)</h3>
    <div class="hmax">
	<table>
	<tr><td width="50%" valign="top">
	    <h3>{$esp->espece}</h3>
	    <p class="directive">Classe</p>
	    <p class="valeur">{$esp->classe_lib}</p>

	    <p class="directive">Type fiche</p>
	    <p class="valeur">{$esp->type_fiche}</p>

	    <p class="directive">Systématique</p>
	    <p class="valeur">{$esp->systematique}</p>

	    <p class="directive">Commentaire</p>
	    <p class="valeur=">{$esp->commentaire}</p>

	    <p class="directive">Ordre</p>
	    <p class="valeur">{$esp->ordre}</p>

	    <p class="directive">Famille</p>
	    <p class="valeur">{$esp->famille}</p>

	    <p class="directive">Nom français</p>
	    <p class="valeur">{$esp->nom_f}</p>

	    <p class="directive">Nom scientifique</p>
	    <p class="valeur">{$esp->nom_s}</p>

	    <p class="directive">Nom anglais</p>
	    <p class="valeur">{$esp->nom_a}</p>
	</td>
	<td width="50%" valign="top">
	    <h3>INPN</h3>
	    <small> <a href="index.php?t=espece_detail&id={$esp->id_espece}&retirer_mnhn=1">Supprimer association INPN</a></small>
	    <p class="directive">{$inpn_libs.regne}</p><p class="valeur">{$inpn->regne}</p>
	    <p class="directive">{$inpn_libs.phylum}</p><p class="valeur">{$inpn->phylum}</p>
	    <p class="directive">{$inpn_libs.classe}</p><p class="valeur">{$inpn->classe}</p>
	    <p class="directive">{$inpn_libs.ordre}</p><p class="valeur">{$inpn->ordre}</p>
	    <p class="directive">{$inpn_libs.famille}</p><p class="valeur">{$inpn->famille}</p>
	    <p class="directive">{$inpn_libs.lb_nom}</p><p class="valeur">{$inpn->lb_nom}</p>
	    <p class="directive">{$inpn_libs.lb_auteur}</p><p class="valeur">{$inpn->lb_auteur}</p>
	    <p class="directive">{$inpn_libs.rang_es}</p><p class="valeur">{$inpn->rang_es}</p>
	    <p class="directive">{$inpn_libs.nom_vern}</p><p class="valeur">{$inpn->nom_vern}</p>
	    <p class="directive">{$inpn_libs.nom_vern_eng}</p><p class="valeur">{$inpn->nom_vern_eng}</p>
	</td></tr>
	</table>
    </div>
    -->
    {if $esp->taxref_inpn_especes <= 0}
    <h3 id="assoc-mnhn">Association avec référentiel MNHN {$inpn_n}</h3>
    <div class="hmax">
	    <ul>
	    {foreach from=$inpn_t item=ref}
		    <li>
			    {$ref.lb_nom} <i>{$ref.lb_auteur}</i>
			    <a href="index.php?t=espece_detail&id={$esp->id_espece}&associer_mnhn={$ref.cd_nom}">associer</a>
		    </li>
	    {/foreach}
	    </ul>
    </div>
    {/if}
    <!--
    <h3 id="pre-com-h">Presence sur les communes</h3>
    <div id="pre-com-cont" class="hmax">Chargement en cours...</div>
    -->
    <h3 id="cit-mois-h">Nombres de citations par mois</h3>
    <div id="cit-mois-cont" class="hmax">Chargement en cours...</div>
    <h3 id="obs-h">Observations</h3>
    <div id="obs-cont" class="hmax">Chargement en cours...</div>
    <h3 id="referentiel-h">Référentiel régional</h3>
    <div id="referentiel-cont" class="hmax">Chargement en cours...</div>
    <h3 id="tags-h">Tags et codes comportement utilisés</h3>
    <div id="tags-cont" class="hmax">Chargement en cours...</div>
    <h3 id="props-h">Propriétés</h3>
    <div id="props-cont" class="hmax">
    		<h4>CHR</h4>
		<form method="post" action="?t=espece_detail&id={$esp->id_espece}">
			Comité d'homologation :
			<select name="id_chr">
				<option value="aucun">Aucun</option>
				{foreach from=$liste_chr item=chr}
				<option value="{$chr.id_chr}" {if $chr.id_chr == $esp->id_chr}selected{/if}>{$chr.nom}</option>
				{/foreach}
			</select>
			<input type="submit" value="Enregistrer"/>
		</form>
		<h4>Limites restitution</h4>
		<div class="bobs-niveau-rest" id="restitution-public">Public</div>
		<div class="bobs-niveau-rest" id="restitution-reseau">Réseau</div>
		<div class="bobs-niveau-rest" id="restitution-structure">Structure</div>
		<hr/>
		<h4>Niveau d'expertise</h4>
		{if $esp->expert}
			Cette espèce nécessite un certain niveau d'expertise ou du matériel pour être identifiée
		{else}
			Cette espèce peut être identifiée par tous
		{/if}
		<h4>Déterminant znieff</h4>
		{if $esp->determinant_znieff}
			Cette espèce est classée déterminante znieff
		{else}
			Cette espèce n'est pas déterminante znieff
		{/if}
		<h4>Exclue des restitutions</h4>
		{if !$esp->exclure_restitution}
			Exclue des restitutions cette espèce n'est pas listées dans les listes communales
		{else}
			Apparait dans les listes communale par exemple
		{/if}
		<h4>Mise à jour carte de répartition (mailles)</h4>
		<a href="?t=espece_detail&id={$esp->id_espece}&maj_carte_repartition=1" class="btn btn-primary">Forcer mise à jour de la carte de répartition</a>
		<hr/>

    </div>
    <h3 id="docs-h">Documents - Images</h3>
    <div id="docs-cont">
	<form enctype="multipart/form-data" action="index.php?t=espece_ajoute_photo" method="post">
		<input type="hidden" name="id_espece" value="{$esp->id_espece}"/>
		<input type="hidden" name="MAX_FILE_SIZE" value="30000000" />
		Auteur de la photo : <input type="text" name="auteur" id="auteur_photo"/>
		Numéro d'utilisateur de l'auteur : <input type="text" name="id_utilisateur" id="auteur_id_utilisateur" value=""/><br/>
		Envoyez ce fichier : <input name="f" type="file" />
		<input type="submit" value="Envoyer le fichier" />
	</form>
	<script>
		//{literal}
		function auteur_rech_sel(e,ui) {
			J('#auteur_id_utilisateur').val(ui.item.value);
			ui.item.value = ui.item.label;
		}
		J('#auteur_photo').autocomplete({source:'?t=autocomplete_observateur'});
		J('#auteur_photo').bind('autocompleteselect', auteur_rech_sel);
		//{/literal}
	</script>
	{foreach from=$esp->documents_liste() item=doc}
		{if $doc->get_type() == 'image'}
			<p>
			Image : {$doc->get_doc_id()} {$doc->get_auteur()} <a class="btn btn-default" href="?t=espece_supprime_doc&id_espece={$esp->id_espece}&doc_id={$doc->get_doc_id()}" class="btn">enlever</a><br/>
			<a href="?t=img&id={$doc->get_doc_id()}" target="_blank"><img src="?t=img&id={$doc->get_doc_id()}&h=320"/></a>
			</p>
		{/if}
	{/foreach}
    </div>
    <h3 id="reftiers-h">Référentiels tiers</h3>
    <div class="reftiers-cont">
    	<table class="table">
	<tr><th>Tiers</th><th>Identifiant</th></tr>
	{foreach from=$esp->liste_references_tiers() item=rt}
		<tr>
			<td>{$rt.tiers}</td>
			<td>
				<form method="post" action="?t=espece_detail&id={$esp->id_espece}">
					{$rt.id_tiers}
					<input type="hidden" name="del_tiers" value="{$rt.tiers}"/>
					<input type="hidden" name="del_id_tiers" value="{$rt.id_tiers}"/>
					<button class="btn btn-primary btn-danger btn-mini">
						<i class="icon-trash icon-white"></i>
					</button>
					{if $rt.url}
						<a class="btn btn-info btn-mini" href="{$rt.url}" target="_blank"><i class="icon-search icon-white"></i></a>
					{/if}

				</form>
			</td>
		</tr>
	{/foreach}
		<tr>
			<form method="post" action="?t=espece_detail&id={$esp->id_espece}">
				<td><input type="text" name="tiers"></td>
				<td>
					<input type="text" name="id_tiers">
					<button class="btn btn-primary">+</button>
				</td>
			</form>
		</tr>
	</table>
	<form method="post" action="?t=espece_detail&id={$esp->id_espece}">
		<input type="hidden" name="gbif_lookup">
		<button>Rechercher automatiquement correspondance GBIF</button>
	</form>
    </div>
</div>

<script>
    {literal}
	function aff_niveau_restitution(niveau_code, niveau_elem, id_espece) {
	    try {
	    	jQuery.get('?t=espece_niveau_restitution&niveau='+niveau_code+'&id='+id_espece, function (data) {
		    	if (data == "1") {
			    	J('#restitution-'+niveau_elem).css('background-color','green');
		    	} else {
			    	J('#restitution-'+niveau_elem).css('background-color','red');
		    	}
	    	});
	    } catch (e) {
		    log(e);
	    }
	}

	function inverse_niveau_restitution(niveau_code, niveau_elem, id_espece) {
		J('#restitution-'+niveau_elem).css('background-color','#aeaeae');
		jQuery.get('?t=espece_niveau_restitution&inverse=1&niveau='+niveau_code+'&id='+id_espece, function (data) {
			if (data == "1") {
				J('#restitution-'+niveau_elem).css('background-color','green');
			} else {
				J('#restitution-'+niveau_elem).css('background-color','red');
			}
		});
	}

    J(document).ready(function(){
	var id_espece = {/literal}{$esp->id_espece}{literal};
    	J('#taxonomie-cont').load('?t=espece_details_taxonomie&id='+id_espece);

	J('.btn').button();
	J('#acc').accordion({
	    activate: function (event,ui){
		var id_espece = {/literal}{$esp->id_espece}{literal};
		switch(ui.newHeader.attr('id')) {
		    /*case 'pre-com-h':
				J('#pre-com-cont').load('?t=espece_details_communes_pre&id='+id_espece);
				break;*/
		    case 'cit-mois-h':
				J('#cit-mois-cont').load('?t=espece_details_citations_par_mois&id='+id_espece);
				break;
		    case 'obs-h':
				J('#obs-cont').load('?t=espece_details_observations&id='+id_espece);
				break;
		    case 'referentiel-h':
				J('#referentiel-cont').load('?t=espece_details_referentiel_region&id='+id_espece);
				break;
		    case 'taxonomie-h':
				J('#taxonomie-cont').load('?t=espece_details_taxonomie&id='+id_espece);
				break;
		    case 'tags-h':
				J('#tags-cont').load('?t=espece_details_tags&id='+id_espece);
				break;
		    case 'props-h':
		    		J('#restitution-public').click(function () { inverse_niveau_restitution(4, 'public', id_espece); });
				J('#restitution-structure').click(function() { inverse_niveau_restitution(2, 'structure', id_espece); });
				J('#restitution-reseau').click(function () { inverse_niveau_restitution(1, 'reseau', id_espece); });
				aff_niveau_restitution(4, 'public', id_espece);
				aff_niveau_restitution(2, 'structure', id_espece);
				aff_niveau_restitution(1, 'reseau', id_espece);
				break;
		}
	    }
	});

    });
    {/literal}
</script>

{/if}
{include file="footer.tpl"}
