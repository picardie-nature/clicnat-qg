{assign var=nombre_ligne value=$observation->nombre_lignes()}
<input type="hidden" id="w_id_import" value="{$observation->id_import}"/>
<input type="hidden" id="w_id_observation" value="{$observation->id_observation}"/>

{if $observation->pret_a_valider()}
<h2>
    Prête pour intégration
    <input type="button" value="Intégrer" onclick="javascript:import_valider_obs({$observation->id_import}, {$observation->id_observation});"/>
</h2>
{/if}

<h3>Localisation</h3>
<input type="text" id="bobs-location" value="{$loc}"/>
<input type="button" value="Localiser" onclick="javascript:recherche();"/>
<input type="button" value="Pointer" onclick="javascript:pointer();"/>
<input type="button" value="Nouveau" onclick="javascript:nouveau();"/>
<pre>
lat/lon DMS {$dms.latitude_dms} {$dms.longitude_dms}
</pre>

{if $observation->id_espace > 0}
	<font color="green">Localisation OK</font>
{else}
	<font color="red">Pointage a faire</font>
{/if}

<h3>Observateurs</h3>
{assign var=t_obs value=$observation->get_observateurs()}
{if $t_obs|@count <= 0}
	{$observation->refait_liste_observateurs()}
	Fichier : {$observation->get_observateurs_import()}<br/>
	{assign var=t_obs value=$observation->get_observateurs()}
{/if}
Fichier : {$observation->get_observateurs_import()}<br/>
{assign var=t_obs value=$observation->get_observateurs()}
Enregistré :
    <ul>
    {foreach from=$t_obs item=observateur}
	<li>{$observateur.nom} {$observateur.prenom} <a href="javascript:import_obs_retirer_observateur({$observation->id_import}, {$observation->id_observation}, {$observateur.id_utilisateur});">x</a></li>
    {/foreach}
    	<li><input type="text" id="z_imp_nom"/></li>
	<script>
	{literal}
	J('#z_imp_nom').autocomplete({
		source: '?t=autocomplete_observateur',
		select: function (event,ui) {
			//{/literal}
			var id_import = {$observation->id_import};
			var id_observation = {$observation->id_observation};
			//{literal}
			console.log('ajouter '+id_import);
			console.log(ui);
			import_obs_ajouter_observateur(id_import, id_observation, ui.item.value);
			return false;
		}
	});
	{/literal}
	</script>
    </ul>

<h3>Date</h3>
Fichier : {$observation->get_date_import()}<br/>
Enregistré : <b>{$observation->date_observation}</b>
<h3>Heure</h3>
Fichier : {$observation->get_heure_import()}<br/>
Enregistré : <b>{$observation->heure_observation}</b>
<h3>Durée</h3>
Fichier : {$observation->get_duree_import()}<br/>
Enregistré : <b>{$observation->duree_observation}</b>


<h3>Citations</h3>
Nombre de lignes : {$nombre_ligne} - ligne de départ : {$observation->num_ligne}<br/>

{section name=loop start=$observation->num_ligne loop=$observation->num_ligne+$nombre_ligne step=1}
<hr/>

Ligne {$smarty.section.loop.index}<br/>
{assign var=ligne value=$smarty.section.loop.index}
{if !$observation->citation_ligne_existe($ligne)}
<form id="fcit{$ligne}">
    <input type="hidden" name="id_observation" value="{$observation->id_observation}"/>
    <input type="hidden" name="num_ligne" value="{$ligne}"/>
    Espèce citée dans le fichier : 
    <span id="esp-{$ligne}">{$observation->get_espece_str($ligne)}</span>
    (<a href="javascript:modifier_nom_espece({$ligne}, {$observation->id_observation})">modifier</a>)
    {assign var=premier value=true}
    {foreach from=$observation->get_especes_recherche($ligne) item=esp name=besp}
	    <p>
		<input {if $premier}checked{/if} type="radio" name="id_espece" value="{$esp.id_espece}" id="esp_choix_{$esp.nom_f}_{$ligne}"/>
		<label for="esp_choix_{$esp.nom_f}_{$ligne}">{$esp.nom_f} <i>{$esp.nom_s}</i></label>
	    </p>
	    {assign var=premier value=false}
    {/foreach}
    <hr>
    Indice fiabilité de l'identification  <input size="2" type="text" name="indice_qualite" value="{$observation->get_indice_fia($ligne)}"/>
    <hr>
    <div id="ligne-{$ligne}"></div>    
    Effectifs :
    <ul>
    {foreach from=$observation->get_effectifs($ligne) item=eff name=effectif}
	<li>
	    <input type="text" size="3" name="eff{$smarty.foreach.effectif.index}" value="{$eff.effectif}"/> -
	    <input type="text" size="3" name="genre{$smarty.foreach.effectif.index}" value="{$eff.genre}"/> -
	    <input type="text" size="3" name="age{$smarty.foreach.effectif.index}" value="{$eff.age}"/> (eff/genre/age)
	</li>
    {/foreach}
    </ul>
    Comportement :
    <ul>
    {foreach from=$observation->get_tags($ligne) item=tag name=tag}
	<li><input type="hidden" name="tag{$smarty.foreach.tag.index}" value="{$tag->id_tag}"/>{$tag->lib}</li>
    {/foreach}
    </ul>
    Commentaire :<br/>
    <textarea name="commentaire">{$observation->get_commentaire($ligne)}</textarea>
    {if $smarty.foreach.besp.total == 1}
	AUTO VALIDATION EN COURS
	<script>creation_citation('fcit{$ligne}', {$ligne});</script>
    {else}
	<input type="button" value="Valider la citation" onclick="javascript:creation_citation('fcit{$ligne}', {$ligne});"/>
    {/if}
</form>
<div id="cit_r_{$ligne}"></div>
{else}
	{assign var=citations value=$observation->citation_import_objs($ligne)}	
	{foreach from=$citations item=citation}
		Citation #{$citation->id_citation}<br/>
		Espèce : {$citation->get_espece()}<br/>
	{/foreach}
	<font color="green">OK</font>
{/if}
{/section}
<input type="button" value="recharger pour integration" onclick="javascript:import_editer_obs({$observation->id_import},{$observation->id_observation});"/>
