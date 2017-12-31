{include file="header.tpl"}
{if $auth_ok}
<div style="float:right;">
{if $tous}
	<a href="?t=especes_index&classe={$classe}&tous=0">Exclure les espèces non citées</a>
{else}
	<a href="?t=especes_index&classe={$classe}&tous=1">Inclure les espèces non citées</a>
{/if}
</div>
<h1>Espèces - {$nom} </h1>
<table class="table">
	<tr>
		<th>Nom vernaculaire</th>
		<th colspan="2">Nom scientifique</th>
		<th>Code</th>
		<th></th>
		<!-- {if $classe == 'O'}
		<th>Nidification</th>
		{/if} -->
		<th>Nb citations ~</th>
	</tr>
{assign var=n value=0}
{assign var=ntref value=0}
{foreach from=$especes item=espece}
	{assign var=n value=$n+1}
	<tr>
		<td> 
			<a href="index.php?t=espece_detail&id={$espece->id_espece}">{$espece->nom_f}</a>
		</td>
		<td>
			<a href="index.php?t=espece_detail&id={$espece->id_espece}">{$espece->nom_s}</a>
		</td>
		<td>
			{if $espece->taxref_inpn_especes}<small>
				{assign var=ntref value=$ntref+1}
				<a class="btn btn-mini" href="http://inpn.mnhn.fr/espece/cd_nom/{$espece->taxref_inpn_especes}" target="_blank">INPN:{$espece->taxref_inpn_especes}</a></small>
			{/if}
		</td>
		<td><span class="label">{$espece->espece}</span></td>
		<td>
			{if $espece->expert}<span class="label label-info">expert</span>{/if}
			{if $espece->exclure_restitution}<span class="label label-warning"><strike>restitution</strike></span>{/if}
			{if $espece->id_espece_parent}<a class="btn btn-mini btn-info" href="?t=espece_detail&id={$espece->id_espece_parent}">sup</a>{/if}
			{if $espece->absent_region}<span class="label label-important">absent</span>{/if}
		</td>
		<td style="text-align:center;"><span class="label">{$espece->n_citations}</span></td>
	</tr>
{/foreach}
</table>
{assign var=p value=$ntref*100/$n}
<p>Rapprochement avec taxref : {$ntref}/{$n} soit {$p|string_format:"%.2f"}%</p>
{/if}
{include file="footer.tpl"}
