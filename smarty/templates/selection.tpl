{include file="header.tpl"}
<div class="pull-right"><a href="?t=selection_info&id={$s->id_selection}" class="btn btn-default">infos</a></div>
<h1>Sélection : {$s} ({$s->n()} citations)</h1>
<form method="get" action="index.php">
<table class="table table-striped">
	<tr>
		<th colspan=2" width="10%">#</th>
		<th width="10%">Date</th>
		<th width="10%">Lieu</th>
		<th width="30%">Espèce</th>
		<th width="10%">N.</th>
		<th width="30%">Observateurs</th>
	</tr>
	{foreach item=e from=$s->tab_citations()}
		<tr id="citation_{$e.id_citation}">
			<td><input type="checkbox" name="retirer_{$e.id_citation}" value="1"/></td>
			<td align="right">
				&nbsp;{$e.id_citation}&nbsp;<a href="?t=citation_edit&id={$e.id_citation}">mod.</a>
			</td>
			<td>{$e.date}</td>
			<td>{$e.lieu}</td>
			<td>{$e.nom_f}</td>
			<td align="right">{$e.nb}</td>
			<td>{$e.observateurs}</td>
		</tr>
	{/foreach}
</table>
<input type="hidden" name="t" value="selection"/>
<input type="hidden" name="id" value="{$s->id_selection}"/>
<input type="submit" value="Retirer de la sélection"/>
</form>
{include file="footer.tpl"}
