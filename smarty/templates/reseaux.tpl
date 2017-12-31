{include file="header.tpl" container_fluid="1"}
<h1>Gestion des réseaux de naturalistes</h1>
<div class="row-fluid">
	<div class="span3">
		<ul>
		{foreach from=$reseaux item=mreseau}
			<li><a href="?t=reseaux&reseau={$mreseau->get_id()}">{$mreseau}</a></li>
		{foreachelse}
			Pas de réseau naturaliste enregistré, commencer par en créer un
		{/foreach}
		</ul>
		<hr/>
		<form method="post" action="?t=reseaux">
			<input type="hidden" name="action" value="nouveau"/>
			<input type="text" name="id" maxlength="2" placeholder="id" required="true"/>
			<input type="text" name="nom" value="" placeholder="nom du réseau" required="true"/>
			<input type="submit" value="Ajouter"/>
		</form>
	</div>
	<div class="span9">
		{if $reseau}
		<h1>Réseau {$reseau}</h1>
		<div class="row">
			<div class="span4">
				<h3>Coordinateurs</h3>
				<ul>
				{foreach from=$reseau->coordinateurs item=coord}
					<li><a href="?t=reseaux&reseau={$reseau->get_id()}&action=retirer_coordinateur&id_utilisateur={$coord->id_utilisateur}">{$coord}</a></li>
				{/foreach}
				</ul>
				<form method="post" action="?t=reseaux&reseau={$reseau->get_id()}">
					<input type="hidden" name="action" value="ajouter_coordinateur"/>
					<input class="auto_utilisateur" type="text" name="id_utilisateur" value="" placeholder="Ajouter un utilisateur" required="true"/>
					<input type="submit" value="Ajouter"/>
				</form>
			</div>
			<div class="span4">
				<h3>Validateurs</h3>
				<ul>
				{foreach from=$reseau->validateurs item=coord}
					<li><a href="?t=reseaux&reseau={$reseau->get_id()}&action=retirer_validateur&id_utilisateur={$coord->id_utilisateur}&id_espece={$coord->id_espece}">{$coord}</a> ({$coord->espece()})</li>
				{/foreach}
				</ul>
				<form method="post" action="?t=reseaux&reseau={$reseau->get_id()}">
					<input type="hidden" name="action" value="ajouter_validateur"/>
					<input class="auto_utilisateur" type="text" name="id_utilisateur" value="" placeholder="Ajouter un utilisateur" required="true"/>
					<input class="auto_espece" type="text" name="id_espece" value="" placeholder="Taxon racine" required="true"/>
					<input type="submit" value="Ajouter"/>
				</form>
			</div>
			<div class="span4">
				<h3>Branches</h3>
				<ul>
				{foreach from=$reseau->liste_branches_especes() item=branche}
					<li><a href="?t=reseaux&reseau={$reseau->get_id()}&action=retirer_branche&id_espece={$branche->id_espece}">{$branche}</a></li>
				{/foreach}
				</ul>
				<form method="post" action="?t=reseaux&reseau={$reseau->get_id()}">
					<input type="hidden" name="action" value="ajouter_branche"/>
					<input class="auto_espece" type="text" name="id_espece" value="" placeholder="Ajouter une branche" required="true"/>
					<input type="submit" value="Ajouter"/>
				</form>
			</div>
		</div>
		<div class="row">
			<div class="span8">
				{assign var=membres value=$reseau->membres()}
				<h3>Membres ({$membres->count()})</h3>
				<form method="post" action="?t=reseaux&reseau={$reseau->get_id()}">
					<input type="hidden" name="action" value="ajouter_membre"/>
					<input class="auto_utilisateur" type="text" name="id_utilisateur" value="" placeholder="Ajouter un membre" required="true"/>
					<input type="submit" value="Ajouter"/>
				</form>
				<ul>
				{foreach from=$membres item=membre}
					<li>{$membre} <a href="?t=reseaux&reseau={$reseau->get_id()}&action=retirer_membre&id_utilisateur={$membre->id_utilisateur}">retirer</a></li>
				{foreachelse}
					Aucun membre
				{/foreach}
				</ul>
			</div>
		</div>
		{else}
			<p>Sélectionner un réseau sur la gauche ou créer un nouveau réseau</p>
		{/if}
	</div>
</div>
{literal}
<script>
function init() {
	J('.auto_espece').autocomplete({
		source: '?t=espece_autocomplete2&nohtml=1&affiche_expert=1'
	});
	J('.auto_utilisateur').autocomplete({
		source: '?t=autocomplete_observateur'
	});
}
J(init);
</script>
{/literal}
{include file="footer.tpl"}
