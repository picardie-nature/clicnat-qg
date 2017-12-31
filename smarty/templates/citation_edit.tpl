{include file="header.tpl"}
<script>
	var id_citation = {$citation->id_citation};
</script>
{assign var=observation value=$citation->get_observation()}
<h1>Modification de la citation {$citation->id_citation}</h1>

{if $observation->brouillard}
	<div style="font-size: 16px; color:red;">Observation en cours de saisie pas encore envoyée</div>
{/if}

<a href="?t=observation_edit&id={$citation->id_observation}">Modifier l'observation #{$citation->id_observation}</a>
<br/>
<div style="float:right; background-color:#eee;padding:10px;">
	<i>Date : {$observation->date_observation|date_format:"%d/%m/%Y"} +/- {$observation->precision_date} jour(s)</i><br/>
	<b>Date début : {if $observation->date_deb}{$observation->date_deb->format("d-m-Y H:i:s")}{/if}<br/>
	Date fin : {if $observation->date_fin}{$observation->date_fin->format("d-m-Y H:i:s")}{/if}<br/></b>
	Date création (obs) : {$observation->date_creation|date_format:"%d/%m/%Y %Hh%M"}<br/>
	Observateur(s) : {foreach from=$observation->get_observateurs() item=o}<a href="?t=profil&id={$o.id_utilisateur}">{$o.nom} {$o.prenom}</a>{/foreach}<br/>
	Saisie : <a href="?t=profil&id={$observation->id_utilisateur}">{$observation->id_utilisateur}</a><br/>
	Loc : {$observation->espace_table} # {$observation->id_espace}<br/>
	{if $observation->espace_table == 'espace_point'}
		{assign var=espace value=$observation->get_espace()}
		Lieu : {$espace}<br/>
		Commune : {$espace->get_commune()}<br/>
		<a href="http://maps.google.fr/maps?q=@{$espace->get_y()},{$espace->get_x()}">Voir sur GMap</a><br/>
	{/if}
	Ref Import : {$citation->ref_import}

	<hr/>
	<fieldset><legend>Tester accès utilisateur</legend>
		Nom : <input type="text" id="recherche_utilisateur">
		<div id="resultat_test_acces"></div>
	</fieldset>
	<hr/>
	<fieldset><legend>Prévalidation</legend>
		<h4>+1</h4>
		<ul>
		{foreach from=$citation->prevalidation_validateurs_positifs() item=val}
			<li><a href="?t=profil&id={$val->id_utilisateur}">{$val}</a></li>
		{/foreach}
		</ul>
		<h4>-1</h4>
		<ul>
		{foreach from=$citation->prevalidation_validateurs_negatifs() item=val}
			<li><a href="?t=profil&id={$val->id_utilisateur}">{$val}</a></li>
		{/foreach}
		</ul>
		<h4>Sans avis</h4>
		<ul>
		{foreach from=$citation->prevalidation_validateurs_sans_avis() item=val}
			<li><a href="?t=profil&id={$val->id_utilisateur}">{$val}</a></li>
		{/foreach}
		</ul>
	</fieldset>
</div>
<script>
{literal}
J('#recherche_utilisateur').autocomplete({
	source:'?t=autocomplete_observateur',
	select: function (event,ui) {
		J('#resultat_test_acces').load("?t=citation_test_acces_utilisateur&id_utilisateur="+ui.item.value+"&id_citation="+id_citation);
	}
});
{/literal}
</script>
<table>
	<tr>
		<th>Espèce</th>
		<td align="right">{$citation->get_espece()}
			<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
				<input type="hidden" name="champ" value="id_espece"/>
				<input type="text" name="valeur" value="{$citation->id_espece}"/>
				<input type="submit" value="modifier"/>
			</form>
		</td>
		<th>Validation</th>
	</tr>
	<tr style="background-color:#eee;">
		<th>Effectif</th>
		<td align="right">
			<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
				<input type="hidden" name="champ" value="nb"/>
				<input type="text" name="valeur" value="{$citation->nb}"/>
				<input type="submit" value="modifier"/>
			</form>
		</td>
		<td>
		
			{if $citation->en_attente_de_validation()}
				<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
					<input type="hidden" name="validation" value="suppr_attv"/>
					<input type="submit" value="Retirer 'en attente de validation'"/>
				</form>
				<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
					<input type="hidden" name="validation" value="suppr_attv_ajout_att_homolog"/>
					<input type="submit" value="Proposer pour homologation"/>
				</form>
			{else}
				Pas en attente
			{/if}
			{if !$citation->invalide()}
				<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
					<input type="hidden" name="validation" value="suppr_attv_ajout_invalide"/>
					<input type="submit" value="Mettre 'invalide'"/>
				</form>
			{else}
				<font color=red>Invalide</font>
				<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
					<input type="hidden" name="validation" value="suppr_attv_invalide"/>
					<input type="submit" value="Enlever statut 'invalide'"/>
				</form>
			{/if}

		</td>
	</tr>
	<tr>
		<th>Indice qualité</th>
		<td>
			<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
				<input type="hidden" name="champ" value="indice_qualite"/> 	
				<select name="valeur">
					<option></option>
					<option value="4" {if $citation->indice_qualite eq 4}selected="true"{/if}>très fort</option>
					<option value="3" {if $citation->indice_qualite eq 3}selected="true"{/if}>fort</option>
					<option value="2" {if $citation->indice_qualite eq 2}selected="true"{/if}>moyen</option>
					<option value="1" {if $citation->indice_qualite eq 1}selected="true"{/if}>faible</option>
				</select>
				<input type="submit" value="modifier"/>
			</form>
		</td>
	</tr>
	<tr style="background-color:#eee;">
		<th>Age</th>
		<td>
			<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
				<input type="hidden" name="champ" value="age"/> 	
				<select name="valeur">
					<option></option>
					{foreach from=$ages item=age}
					<option value="{$age.val}" {if $citation->age eq $age.val}selected="true"{/if}>{$age.val} {$age.lib}</option>
					{/foreach}
				</select>
				({$citation->age})
				<input type="submit" value="modifier"/>
			</form>
		</td>
	</tr>
	<tr>
		<th valign="top">Sexe</th>
		<td>
			<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
				<input type="hidden" name="champ" value="sexe"/> 	
				<select name="valeur">
					<option></option>
					{foreach from=$genres item=sexe}
					<option value="{$sexe.val}" {if $citation->sexe eq $sexe.val}selected="true"{/if}>{$sexe.val} {$sexe.lib}</option>
					{/foreach}
				</select>
				({$citation->sexe})
				<input type="submit" value="modifier"/>
			</form>
		</td>
	</tr>

	<tr style="background-color:#eee;">
		<th valign="top">Tags</th>
		<td colspan="2">
			<ul>
			{foreach from=$citation->get_tags() item=tag}
				<li style="font-size:12px;">
					<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
						{$tag.lib} 
						{if $tag.v_int}<span class="label label-info">{$tag.v_int}</span>{/if}
						{if $tag.v_text}<span class="label label-success">{$tag.v_text}</span>{/if}
						<input type="hidden" name="id_tag" value="{$tag.id_tag}"/>
						<input type="hidden" name="champ" value="tag_supprimer"/>
						<input type="submit" value="enlever"/>
					</form>
				</li>
			{/foreach}
				<li>
					<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
						<input type="text" id="i_tag_recherche"/>
						<script>
						{literal}
						J('#i_tag_recherche').autocomplete({
							source: 'index.php?'+J.param({t: 'tag_citations_autocomplete'}),
							select: function (event, ui) {
								var s = J('#s_id_tag');
								s.val('Ajouter '+ui.item.value);
								s.toggle();
								J('#i_id_tag').val(ui.item.id);
							}
						});
						{/literal}
						</script>
						<input type="hidden" name="id_tag" id="i_id_tag"/>
						<input type="hidden" name="champ" value="tag_ajouter"/>
						<br/><input type="submit" value="ajouter " id ="s_id_tag" style="display:none;"/>
					</form>
				</li>
			</ul>
		</td>
	</tr>
</table>
<h1>Historique et  commentaires</h1>
<fieldset><legend>Commentaire principal</legend>
<pre>{$citation->commentaire}</pre>
</fieldset>
{foreach from=$citation->get_commentaires() item=c}
<fieldset><legend>{$c->date_commentaire|date_format:"%d-%m-%Y"} - {$c->utilisateur} - #{$c->id_commentaire}</legend>
	{if $c->type_commentaire=='info'}
		<div style="float:right;">
			<form method="get" action="index.php">
				<input type="hidden" name="t" value="citation_edit"/>
				<input type="hidden" name="id" value="{$citation->id_citation}"/>
				<input type="hidden" name="supprimer_commentaire" value="{$c->id_commentaire}"/>
				<input type="submit" value="Supprimer"/>
			</form>
		</div>
	{/if}
	{$c->commentaire}	
</fieldset>	
{/foreach}
<form method="post" action="?t=citation_edit&id={$citation->id_citation}">
	<input type="hidden" name="validation" value="ajouter_commentaire"/>
	Commentaire a ajouter :<br/>
	<textarea name="texte" cols="50" rows="5"></textarea>
	<input type="submit" value="Ajouter un commentaire"/>
</form>

<h1>Documents</h1>
{foreach from=$citation->documents_liste() item=doc}
<fieldset>
	<div style="float:right;">
	<form method="get" action="index.php">
		Ref : {$doc->get_doc_id()} 
		<input type="hidden" name="t" value="citation_edit"/>
		<input type="hidden" name="id" value="{$citation->id_citation}"/>
		<input type="hidden" name="document_detacher" value="{$doc->get_doc_id()}"/>
		<input type="submit" value="Supprimer"/>
	</form>
	</div>
	{if $doc->get_type() == 'image'}
		<a href="?t=img&id={$doc->get_doc_id()}"><img src="?t=img&id={$doc->get_doc_id()}&h=320"></a>
	{/if}
</fieldset>
{foreachelse}
	Aucun document attaché
{/foreach}
{include file="footer.tpl"}
