{include file="header.tpl"}
<div class="row">
	<div class="span8">
		<div class="well">
			<p class="directive">Nom de la sélection :</p>
			<p class="valeur">{$s->nom_selection}</p>

			<p class="directive">Nombre de citations :</p>
			<p class="valeur">{$s->n()}</p>
		</div>
	</div>
	<div class="span4">
		<ul>
		    <li><a href="?t=selection_csv&encoding=utf8&id={$s->id_selection}">fichier CSV (utf8)</a></li>
		    <li><a href="?t=selection_csv&encoding=latin1&id={$s->id_selection}">fichier CSV (latin1, iso8859-1)</a></li>
		    <li><a href="?t=selection_shp&sel={$s->id_selection}&epsg_id=2154">fichier shp (Lambert 93)</a></li>
		    <li><a href="?t=selection_shp&sel={$s->id_selection}&epsg_id=27582">fichier shp (Lambert 2 étendue)</a></li>
		    <li><a href="?t=selection_shp&sel={$s->id_selection}&epsg_id=4326">fichier shp (WGS 84 - GPS)</a></li>
		    <li><a href="?t=selection_shp_atlas&sel={$s->id_selection}">fichier atlas (Lambert 93)</a></li>
		    <li><a href="?t=selection_shp_mix&sel={$s->id_selection}">fichier atlas agrégé (Lambert 93)</a></li>
		    <li><a href="?t=selection&id={$s->id_selection}">Voir les données</a></li>
		</ul>
	</div>
</div>
<div class="row" style="background-color:#aeaeae;">
	<div class="span4">
		<fieldset>
			<legend>Changement de propriétaire</legend>
			<p>Attribuer cette sélection de d'occurrences a un autre observateur.
			Il pourra consulter son contenu.</p>
			<form method="get" action="index.php">
				<input type="hidden" name="t" value="selection_info">
				<input type="hidden" name="do" value="changer_proprio">
				<input type="hidden" name="id" value="{$s->id_selection}">
				Identifiant nouveau propriétaire :
				<input type="text" id="proprio" name="id_utilisateur" value=""><span id="lbl_proprio"></span><br/>
				<button>Changer</button>
			</form>
		</fieldset>
	</div>
	<div class="span4">
		<fieldset>
			<legend>Validation</legend>
			<form method="get" action="index.php">
				<input type="hidden" name="t" value="selection_info"/>
				<input type="hidden" name="do" value="valider"/>
				<input type="hidden" name="id" value="{$s->id_selection}"/>
				Identifiant validateur <input type="text" id="validateur" name="id_valid" value=""/><span id="lbl_validateur"></span><br/>
				<button>Valider le contenu de la sélection</button>
				les observations en attente de validation perdent leur étiquette en attente, les autres
				ne seront pas modifiées (une observation invalide ne deviendra pas valide)	
			</form> 
		</fieldset>
	</div>
	<div class="span4">
		<fieldset>
			<legend>Ajout de citations par leur numéro</legend>
			<form method="post" action="index.php?t=selection_info&do=ajouter_ids&id={$s->id_selection}">
				<textarea name="ids" style="width:90%; height:100px;"></textarea>
				<button>Ajouter</button>
			</form>
		</fieldset>
	</div>
</div>
<hr/>
<div class="row" style="background-color:#dedede;">
	<div class="span4">
		<fieldset>
			<legend>Attribuer la sélection à une structure</legend>
			<p>Ajoute une étiquette structure avec l'id de la structure sur chaque citation sauf si elle y est déjà</p>
			<form method="post" action="index.php?t=selection_info&do=associer_structure&id={$s->id_selection}">
				Structure <select name="txt_id">
					<option value=""></option>
				{foreach from=$structures item=structure}
					{if $structure->txt_id}
						<option value="{$structure->txt_id}">{$structure} <small>({$structure->txt_id})</small></option>
					{/if}
				{/foreach}
				</select>
				<input type="submit" value="Ajouter"/>
			</form>
		</fieldset>
	</div>
	<div class="span4">
		<fieldset>
			<legend>Ajouter un protocole sur chaque citation</legend>
			<form method="post" action="index.php?t=selection_info&do=associer_protocole&id={$s->id_selection}">
				Structure <select name="txt_id">
					<option value=""></option>
				{foreach from=$protocoles item=protocole}
					<option value="{$protocole->id_protocole}">{$protocole}</option>
				{/foreach}
				</select>
				<input type="submit" value="Ajouter"/>
			</form>
		</fieldset>
	</div>
	<div class="span4">
		<fieldset>
			<legend>Ajouter une étiquette sur chaque citation</legend>
			<form method="post" action="index.php?t=selection_info&do=ajouter_etiquette&id={$s->id_selection}">
				Étiquette : <input type="hidden" name="id_tag" value="" id='r_id_tag'/>
				<input type="text" name="tag" id="r_tag"/>
				<input type="submit" value="Ajouter">
			</form>
			<script>
				// {literal}
				J('#r_tag').autocomplete({
					source: '?t=autocomplete_tag_citation',
					select: function (event,ui) {
						J('#r_id_tag').val(ui.item.value);
						J('#r_tag').val(ui.item.label);
						return false;
					}
				});
				// {/literal}
			</script>
		</fieldset>
	</div>
</div>
<hr/>
<div class="row" style="background-color:#aeaeae;">
 	<div class="span4">
 		<fieldset>
			<legend>Retirer une étiquette sur chaque citation</legend>
			<form method="post" action="index.php?t=selection_info&do=retirer_etiquette&id={$s->id_selection}">
				Étiquette : 
				<input type="text" name="id_tag" value="" id='ret_id_tag' placeholder="numéro de l'étiquette"/><br/>
				Nom : <input type="text" name="tag" id="ret_tag" placeholder="rechercher une étiquette"/>
				<input type="submit" value="Retirer">
			</form>
			<script>
				// {literal}
				J('#ret_tag').autocomplete({
					source: '?t=autocomplete_tag_citation',
					select: function (event,ui) {
						J('#ret_id_tag').val(ui.item.value);
						J('#ret_tag').val(ui.item.label);
						return false;
					}
				});
				// {/literal}
			</script>
		</fieldset>
	</div>
	<div class="span4">
		<fieldset>
			<legend>Retirer une étiquette sur chaque citation</legend>
			<form method="post" action="index.php?t=selection_info&do=retirer_etiquette&id={$s->id_selection}">
				Étiquette : 
				<input type="text" name="id_tag" value="" id='ret_id_tag' placeholder="numéro de l'étiquette"/><br/>
				Nom : <input type="text" name="tag" id="ret_tag" placeholder="rechercher une étiquette"/>
				<input type="submit" value="Retirer">
			</form>
			<script>
				// {literal}
				J('#ret_tag').autocomplete({
					source: '?t=autocomplete_tag_citation',
					select: function (event,ui) {
						J('#ret_id_tag').val(ui.item.value);
						J('#ret_tag').val(ui.item.label);
						return false;
					}
				});
				// {/literal}
			</script>
		</fieldset>
	</div>

	<div class="span4">
		<fieldset>
			<legend>Invalider ou remettre en attente de val. le contenu de la sélection</legend>
			<form method="post" action="index.php?t=selection_info&do=invalider&id={$s->id_selection}">
				<input type="submit" value="Invalider">
			</form>
			<form method="post" action="index.php?t=selection_info&do=remettre_en_attente&id={$s->id_selection}">
				<input type="submit" value="Remettre les citations en attente de validation"/>
			</form>
		</fieldset>
	</div>
</div>
<hr/>
<div class="row" style="background-color:#dedede;">
 	<div class="span4">
 		<fieldset>
			<legend>Remplir avec extraction agent</legend>
			<form method="post" action="index.php?t=selection_info&do=fill_agent_etat&id={$s->id_selection}">
				Identifiant requête : <input type="text" name="eid" value=""/>
				<input type="submit" value="Exécuter"/>
			</form>
		</fieldset>
	</div>
	<div class="span4">
		<fieldset>
			<legend>Opérations</legend>
			<a href="?t=selection_info&do=vider&id={$s->id_selection}">Vider</a>
		</fieldset>
	</div>
</div>
<div class="row">
	<div class="span8">
		<fieldset>
			<legend>Définition XML de l'extraction</legend>
			<pre>{$s->extraction_xml|escape}</pre>
		</fieldset>
	</div>
</div>
<script>
	{literal}
		J('#proprio').autocomplete({	
			source: '?t=autocomplete_observateur',
			select: function (event,ui) {
				J('#lbl_proprio').html(ui.item.label);
			}

		});
		J('#validateur').autocomplete({
			source: '?t=autocomplete_observateur',
			select: function (event,ui) {
				J('#lbl_validateur').html(ui.item.label);
			}
		});
	{/literal}
</script>
{include file="footer.tpl"}
