<fieldset>
	<legend>Arbre</legend>
	{assign var=parents value=$espece->taxons_parents()}
	{assign var=p value=0}
	{foreach item=parent from=$parents}
		{section name=b start=0 loop=$p step=1}&nbsp;&nbsp;{/section}<a href="?t=espece_detail&id={$parent->id_espece}">{$parent}</a><br/>
		{assign var=p value=$p+1}
	{/foreach}
	<form method="post" action="?t=espece_detail&id={$espece->id_espece}">
		<label for="id_espece_parent">Modifier ou définir le taxon supérieur</label>
		<input placeholder="Modifier ou définir le taxon supérieur" type="text" name="id_espece_parent" id="id_espece_parent" value="{$espece->id_espece_parent}">
		<input type="submit" value="Enregistrer">
		<script>
		{literal}
		J('#id_espece_parent').autocomplete({
			source: '?t=espece_autocomplete2&nohtml=1&affiche_expert=1&forcer_absent=1',
			select: function (event,ui) {
			    event.target.value = ui.item.value;
			    return false;
			}
		});

		{/literal}
		</script>
	</form>
<fieldset>
	<legend>Nom vernaculaire et scientifique</legend>
	<span class="directive">Nom vernaculaire : </span> {$espece->nom_f}<br/>
	<span class="directive">Nom scientifique : </span> {$espece->nom_s}<br/>
</fieldset>
<br/>
<fieldset>
	<legend>Taxon lié dans le référentiel INPN</legend>
	{if $inpn->cd_nom != $inpn->cd_ref}
		<b>Attention, ce n'est pas un taxon de référence</b><br/>
	{/if}
	<span class="directive">Nom vernaculaire : </span> {$inpn->nom_vern}<br/>
	<span class="directive">Nom scientifique : </span> {$inpn->lb_nom} {$inpn->lb_auteur}<br/>
	<span class="directive">Identifiant du taxon : </span> {$inpn->cd_nom}
	<span class="directive">Taxon de référence : </span> {if $inpn->cd_nom == $inpn->cd_ref}oui{else}non{/if}<br/>
</fieldset>
<br/>
<fieldset>
	<legend>Taxons associés</legend>
	<table class="table">
		<tr>
			<th>cd_nom</th>
			<th>Nom vernaculaire</th>
			<th>Nom scientifique</th>
		</tr>
		{if $inpn}
			{foreach from=$inpn->get_references() item=e}
			<tr>
				<td>{$e.cd_nom} {if $e.cd_nom == $e.cd_ref}<span class="label label-default">ref</span>{/if}</td>
				<td>{$e.nom_vern}</td>
				<td>{$e.lb_nom} {$e.lb_auteur}</td>
			</tr>
			{/foreach}
		{/if}
	</table>
</fieldset>
