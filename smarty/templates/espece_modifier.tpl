{include file="header.tpl"}
<h1>Modifier une espèce</h1>
<form name="espece" method="post" action="?t=espece_detail&id={$e->id_espece}">
    <table>
	<tr><td valign="top" width="50%">
	<input type="hidden" name="mise_a_jour" value="1"/>
	<div class="directive">Classe</div>
	<div class="valeur">
		<select name="classe">
		{foreach from=$menu_classes item=classe key=k}
			<option value="{$k}" {if $e->classe == $k}selected="true"{/if}>{$classe}</option>
		{/foreach}
		</select>
	</div>

	<!--
	<div class="directive">Type de fiche</div>
	<div class="valeur"><input type="text" name="type_fiche" value="{$e->type_fiche}"/></div>
	-->
	<div class="directive">Systématique</div>
	<div class="valeur"><input type="text" name="systematique" value="{$e->systematique}"/></div>

	<div class="directive">Ordre</div>
	<div class="valeur"><input type="text" name="ordre" value="{$e->ordre}"/></div>

	<div class="directive">Famille</div>
	<div class="valeur"><input type="text" name="famille" value="{$e->famille}"/></div>

	<div class="directive">Nom français</div>
	<div class="valeur"><input type="text" name="nom_f" value="{$e->nom_f}"/></div>

	<div class="directive">Nom scientifique</div>
	<div class="valeur"><input type="text" name="nom_s" value="{$e->nom_s}"/></div>

	<div class="directive">Nom anglais</div>
	<div class="valeur"><input type="text" name="nom_a" value="{$e->nom_a}"/></div>

	<div class="directive">Nom picard</div>
	<div class="valeur"><input type="text" name="nom_pic" value="{$e->nom_pic}"/></div>
    </td><td valign="top">
	Pour modifier ces champs il faut se rendre sur <a href="http://fiches.obs.picardie-nature.org/">fiches.obs.picardie-nature.org</a><br/>
	<div class="directive">Commentaire</div>
	<div class="valeur"><!-- <textarea cols="50" rows="6" name="commentaire">-->{$e->commentaire}<!--</textarea>--></div>

	<div class="directive">Habitat</div>
	<div class="valeur"><!-- <textarea cols="50" rows="6" name="habitat"> -->{$e->habitat}<!-- </textarea> --></div>

	<div class="directive">Menace</div>
	<div class="valeur"><!-- <textarea cols="50" rows="6" name="menace"> -->{$e->menace}<!-- </textarea> --></div>
	
	<div class="directive">Action de conservation</div>
	<div class="valeur"><!-- <textarea cols="50" rows="6" name="action_conservation"> -->{$e->action_conservation}<!-- </textarea> --></div>
	
	<div class="directive">Commentaire du statut de menace</div>
	<div class="valeur"><!-- <textarea cols="50" rows="6" name="commentaire_statut_menace"> -->{$e->commentaire_statut_menace}<!-- </textarea> --></div>

	<div class="directive">Code de l'espèce FNAT</div>
	<div class="valeur"><input type="text" name="espece" value="{$e->espece}"/></div>

	<div class="directive">Superficie max pour utilisation des données en m²</div>
	<div class="valeur"><input type="text" name="superficie_max" value="{$e->superficie_max}"/></div>

	<div class="directive">Exclure des restitutions<br/><small>Taxon pas pris en compte sur le nbre d'espèces d'une commune</small></div>
	<div class="valeur">
		{include file="__select_bool.tpl" champ="exclure_restitution" valeur=$e->exclure_restitution}
	</div>
	<div class="directive">Déterminant ZNIEFF</div>
	<div class="valeur">
		{include file="__select_bool.tpl" champ="determinant_znieff" valeur=$e->determinant_znieff}
	</div>
	<div class="directive">Invasif</div>
	<div class="valeur">
		{include file="__select_bool.tpl" champ="invasif" valeur=$e->invasif}
	</div>
	<div class="directive">Saisie réservé expert</div>
	<div class="valeur">
		{include file="__select_bool.tpl" champ="expert" valeur=$e->expert}
	</div>
	<div class="directive">Taxon absent dans la région</div>
	<div class="valeur">
		{include file="__select_bool.tpl" champ="absent_region" valeur=$e->absent_region}
	</div>
	<div class="directive">Indice sensibilité SINP national (de 0 à 4)</div>
	<div class="valeur">
		<input type="text" name="sinp_sensibilite_national" value="{$e->sinp_sensibilite_national}"/>
	</div>
	<div class="directive">Indice sensibilité SINP local (de 0 à 4)</div>
	<div class="valeur">
		<input type="text" name="sinp_sensibilite_local" value="{$e->sinp_sensibilite_local}"/>
	</div>
	<div class="directive">Remarquable<br/><small>On demandera la fourniture d'une photo ou d'un commentaire pour préciser l'observation</small></div>
	<div class="valeur">
		{include file="__select_bool.tpl" champ="remarquable" valeur=$e->remarquable}
	</div>
	<div class="directive">Catégorie arbo<br/><small>Taxon utilisé comme point de départ pour lister les espèces de la base</small></div>
	<div class="valeur">
		{include file="__select_bool.tpl" champ="categorie_arbo" valeur=$e->categorie_arbo}
	</div>
	<div class="valeur"><input type="submit" value="Enregistrer"/></div>
    </td>
    </table>
</form>
{include file="footer.tpl"}
