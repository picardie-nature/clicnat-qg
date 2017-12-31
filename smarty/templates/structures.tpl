{include file="header.tpl" container_fluid=1}
<div class="row-fluid">
	<div class="span3">
		<div class="well">
			<h3>Structures</h3>
			<form method="post" action="?t=structures" class="form">
				<input type="text" placeholder="Nom nouvelle structure" name="nom"/>
				<input type="hidden" name="action" value="ajouter_structure"/>
				<button type="submit">Ajouter</button>
			</form>
			<ul class="nav nav-pills nav-stacked">
			{foreach from=$structures item=s name=structs}
				<li>
					<a href="?t=structures&id_structure={$s->id_structure}">{$s}</a>
				</li>
			{/foreach}
			</ul>
		</div>
	</div>
	<div class="span6">
		{if $structure}
			<h1>{$structure}</h1>
			{if !$structure->type_mad}
				<h3>Choisir type de mise à disposition</h3>
				<form method="post" action="?t=structures&id_structure={$structure->id_structure}" class="form">
					<input type="hidden" name="action" value="type_mad">
					<label for="liste_types_mad">Méthode de sélection des données</label>
					<select id="liste_types_mad" name="type_mad">
						<option value="mad_classes">Par classes d'espèces</option>
						<option value="mad_communes">D'après une liste de communes</option>
						<option value="mad_espaces">D'après une liste de polygones</option>
						<option value="mad_xml">D'après une extraction</option>
					</select>
					<button type="submit">Passer à la définition</button>
				</form>
			{else}
				{if $structure->type_mad eq "mad_classes"}
					<h4>Sélection des données selon les classes d'espèces</h4>
					<form method="post" action="?t=structures&id_structure={$structure->id_structure}" class="form">
						<input type="hidden" name="action" value="maj_liste_classes">
						{foreach from=$classes item=c key=k}
							<label for="c{$k}">
								<input id="c{$k}" name="classes[]" type="checkbox" value="{$k}" {if $structure->a_classe($k)}checked=1{/if}> {$c}
							</label>
						{/foreach}
						<button type="submit">Enregistrer</button>
					</form>
				{elseif $structure->type_mad eq "mad_communes"}
					<h4>Sélection des données selon une liste de communes</h4>
					<input placeholder="recherche le nom d'une commune" type="text" id="com">
					<form id="form_commune" method="post" action="?t=structures&id_structure={$structure->id_structure}" class="form" style="display:none;">
						<input type="hidden" name="action" value="ajoute_commune">
						<input type="hidden" name="id_espace_commune" id="id_form_commune" value="">
						<button type="submit" id="lbl_commune">Enregistrer</button>
					</form>
					<h4>Liste des sites</h4>
					{foreach from=$structure->communes() item=c}
						<form method="post" action="?t=structures&id_structure={$structure->id_structure}" class="form">
							<input type="hidden" name="action" value="retire_commune">
							<input type="hidden" name="id_espace_commune" value="{$c->id_espace}">
							<button>{$c}</button>
						</form>
					{/foreach}
					</ul>
					<script>
						//{literal}
						J('#com').autocomplete({
							source: '?t=autocomplete_commune',
							select: function (event,ui) {
								J('#form_commune').css('display','block');
								J('#id_form_commune').val(ui.item.value);
								J('#lbl_commune').html("Ajouter "+ui.item.label);
								return false;
							}
						});
						//{/literal}
					</script>
				{elseif $structure->type_mad eq "mad_espaces"}
					<h4>Sélection des données selon une liste de polygones</h4>
					<form method="post" action="?t=structures&id_structure={$structure->id_structure}" class="form">
						<label>Référence utiliser dans la table espace_structure</label>
						<input type="hidden" name="action" value="maj_ref_espace_structure"/>
						<input type="text" name="ref_espace_structure" value="{$structure->data.ref_espace_structure}"/>
						<button type="submit">Enregistrer</button>
					</form>
					<ul>
						{foreach from=$structure->espaces_structures() item=e}
							<li>{$e} #{$e->id_espace}</li>
						{/foreach}
					</ul>
				{elseif $structure->type_mad eq "mad_xml"}
					<h4>Sélection des données selon une extraction</h4>
					<form method="post" action="?t=structures&id_structure={$structure->id_structure}" class="form">
						<input type="hidden" name="action" value="maj_xml"/>
						<textarea style="height:30em; width: 100%;" name="xml">{$structure->data.xml}</textarea>
						<button type="submit">Enregistrer</button>
					</form>
				{/if}
			{/if}

			<div>
				{if $apercu_possible}
				<h4>Aperçu des extractions générées</h4>
					{foreach from=$structure->get_extractions() item=e}
						<pre>{$e->sauve_xml_html_preview()}</pre>
					{/foreach}
				{/if}
				
			</div>
		{else}
			Sélectionnez une structure
		{/if}
	</div>
	<div class="span3">
		{if $structure}
		<div class="well">
			Données mises à disposition :
			{$structure->nb_donnees_mad()}
		</div>
		<div class="well">
			Identifiant texte
			<form method="post" action="?t=structures&id_structure={$structure->id_structure}">
				<input type="hidden" name="action" value="identifiant_txt_id"/>
				<input type="text" name="txt_id" value="{$structure->txt_id}"/>
				<input type="submit" value="Enregistrer"/>
			</form>
			<p>Ne pas modifier sans une bonne raison, le lien entre citations et structure sera brisé !</p>
		</div>
		<div class="well">
			<h4>Membres</h4>
			{foreach from=$structure->membres() item=membre}
				<form method="post" action"?t=structures&id_structure={$structure->id_structure}">
					<input type="hidden" name="action" value="retirer_membre">
					<input type="hidden" name="id_utilisateur" value="{$membre->id_utilisateur}">
					<button type="submit" title="{$membre->mail}">{$membre}</button>
				</form>
			{/foreach}
			<input type="text" placeholder="Ajouter une personne" id="nom_membre"/>
			<form id="form_membre" method="post" action="?t=structures&id_structure={$structure->id_structure}" class="form" style="display:none;">
				<input type="hidden" name="action" value="ajoute_membre">
				<input type="hidden" name="id_utilisateur" id="id_utilisateur_membre" value="">
				<button type="submit" id="lbl_membre">Enregistrer</button>
			</form>
			<script>
				//{literal}
				J('#nom_membre').autocomplete({
					source:'?t=autocomplete_observateur',
					select: function (evt, ui) {
						J('#form_membre').css('display','block');
						J('#id_utilisateur_membre').val(ui.item.value);
						J('#lbl_membre').html("Ajouter "+ui.item.label);
						return false;
					}
				});
				//{/literal}
			</script>
		</div>
		<div class="well">
			<h4>Diffusion restreintes</h4>
			{foreach from=$structure->diffusions_restreintes() item=dr}
				<form method="post" action"?t=structures&id_structure={$structure->id_structure}">
					<input type="hidden" name="action" value="retirer_diffusion_restreinte">
					<input type="hidden" name="id_utilisateur" value="{$dr->id_utilisateur}">
					<button type="submit" title="{$dr->mail}">{$dr}</button>
				</form>
			{/foreach}
			<input type="text" placeholder="Ajouter une personne" id="nom_diffusion_restreinte"/>
			<form id="form_diffusion_restreinte" method="post" action="?t=structures&id_structure={$structure->id_structure}" class="form" style="display:none;">
				<input type="hidden" name="action" value="ajoute_diffusion_restreinte">
				<input type="hidden" name="id_utilisateur" id="id_utilisateur_diffusion_restreinte" value="">
				<button type="submit" id="lbl_diffusion_restreinte">Enregistrer</button>
			</form>
			<script>
				//{literal}
				J('#nom_diffusion_restreinte').autocomplete({
					source:'?t=autocomplete_observateur',
					select: function (evt, ui) {
						J('#form_diffusion_restreinte').css('display','block');
						J('#id_utilisateur_diffusion_restreinte').val(ui.item.value);
						J('#lbl_diffusion_restreinte').html("Ajouter "+ui.item.label);
						return false;
					}
				});
				//{/literal}
			</script>
		</div>
		{/if}
	</div>
</div>
{include file="footer.tpl"}
