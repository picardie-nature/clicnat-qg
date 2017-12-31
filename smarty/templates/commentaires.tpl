{include file="header.tpl"}
<h1>{$n} derniers commentaires</h1>
<table width="100%" class="table">
<tr>
	<th>#</th>
	<th>Obj</th>
	<th>Message</th>
	<th>Auteur</th>
</tr>
{foreach from=$commentaires item=c}
<tr>
	<td>{$c.id_commentaire}</td>
	<td>
		{if $c.tble == 'citations_commentaires'}
			<a href="?t=citation_edit&id={$c.ele_id}">citation #{$c.ele_id}</a>
		{elseif $c.tble == 'observations_commentaires'}
			<a href="?t=observation_edit&id={$c.ele_id}">observation #{$c.ele_id}</a>
		{/if}
	</td>
	<td>{$c.commentaire}</td>
	<td>{$c.nom} {$c.prenom}</td>
</tr>
{/foreach}
</table>
{include file="footer.tpl"}
