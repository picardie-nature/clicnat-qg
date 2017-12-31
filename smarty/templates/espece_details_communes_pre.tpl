(<b>{$n}</b> commune(s))<br/>
<ul>
{foreach from=$liste item=commune}
	<li><a href="index.php?t=commune_detail&id={$commune.id}">{$commune.nom} {$commune.mois}/{$commune.annee}</a></li>
{/foreach}
</ul>
