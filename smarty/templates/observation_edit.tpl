{include file="header.tpl"}
<h1>Modification de l'observation {$observation->id_observation}</h1>
{if $observation->brouillard}
	<div style="font-size: 16px; color:red;">Observation en cours de saisie pas encore envoyée</div>
{/if}
<h2>Date d'observation</h2>
<form method="post" action="index.php?t=observation_edit&id={$observation->id_observation}">
	<input type="hidden" name="champ" value="date_observation"/>
	<input type="text" size="10" name="valeur" value="{$observation->date_observation|date_format:"%d/%m/%Y"}" id="cd"/>
	<input type="submit" value="modifier"/>
</form>
<script>J('#cd').datepicker();</script>

<h2>Heure de l'observation</h2>
<form method="post" action="index.php?t=observation_edit&id={$observation->id_observation}">
	<b>{$observation->heure_observation}</b> 
	<br/>remplacer ou définir avec :
	<input type="hidden" name="champ" value="heure_observation"/>
	<input type="text" size=2 name="h"/>h
	<input type="text" size=2 name="m"/>m
	<input type="text" size=2 name="s"/>s
	<input type="submit" value="modifier" />
</form>

<h2>Observateurs</h2>
<form method="post" action="index.php?t=observation_edit&id={$observation->id_observation}">
	<input type="hidden" name="champ" value="ajoute_observateur"/>
	<input type="text" size="10" name="valeur" value="" id="a_observateur"/>
	<input type="submit" value="ajouter"/>
</form>
<script>
	{literal}
	J('#a_observateur').autocomplete({source:'?t=autocomplete_observateur'});
	{/literal}
</script>
{foreach from=$observation->get_observateurs() item=o}
	<form method="post" action="index.php?t=observation_edit&id={$observation->id_observation}">
		{$o.nom} {$o.prenom}
		<input type="hidden" name="champ" value="retire_observateur"/>
		<input type="hidden" size="10" name="valeur" value="{$o.id_utilisateur}"/>
		<input type="submit" value="retirer"/>
	</form>
{/foreach}
<h2>Citations</h2>
{foreach from=$observation->get_citations() item=c}
	<a href="?t=citation_edit&id={$c->id_citation}">{$c->get_espece()}</a>
{/foreach}
<h2>Historique</h2>
{foreach from=$observation->get_commentaires() item=c}
	<p>
		<i>{$c->type_commentaire}</i> {$c->date_commentaire_f} par {$c->utilisateur}<br/>
		{$c->commentaire} 
	</p>
{/foreach}
{include file="footer.tpl"}
