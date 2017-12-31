{include file="header.tpl"}
{$n} citations<br/>
<script>
{literal}
function cacher(c) {
	J('.c'+c).toggle();
}
{/literal}
</script>
<a href="javascript:cacher('O');">Oiseaux</a>
<a href="javascript:cacher('I');">Insectes</a>
<a href="javascript:cacher('M');">Mammifères</a>
<a href="javascript:cacher('A');">Araignées</a>

<table>
{foreach from=$citations item=citation}
	{assign var=observation value=$citation->get_observation()}
	{assign var=espece value=$citation->get_espece()}
	<tr class="c{$espece->classe}">
		<td>{$espece->classe}</td>
		<td>{$citation->id_citation}</td>
		<td>{$observation->date_observation|date_format:"%d-%m-%Y"}</td>
		<td>{$espece}</td>
		<td>{foreach from=$observation->get_observateurs() item=o}{$o.nom} {$o.prenom}{/foreach}</td>
		<td><a target="_blank" href="?t=citation_edit&id={$citation->id_citation}">ouvrir</a></td>
	</tr>
{/foreach}
</table>
{include file="footer.tpl"}
