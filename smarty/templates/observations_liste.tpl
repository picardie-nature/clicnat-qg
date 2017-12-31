<ul>
{foreach from=$observations key=k item=obs}
	<li>
		{foreach from=$obs->get_especes_vues() key=kk item=esp}
			{if $surligner_espece == $esp.id_espece} <b style="background-color:yellow;"> {/if}
			{if $esp.total != 0}{$esp.total}{/if} 
			<a href="?t=espece_detail&id={$esp.id_espece}" title="{$esp.nom_s}">{$esp.nom_f}</a>
			{if $surligner_espece == $esp.id_espece} </b> {/if}
		{foreachelse}
		    Aucune espèce vue (possible observation négative)
		{/foreach}
		<br/>
		le {$obs->date_obs_tstamp|date_format:$format_date_complet} 
		par 
		{foreach from=$obs->get_observateurs() item=observ}
			<a href="?t=profil&id={$observ.id_utilisateur}">{$observ.nom} {$observ.prenom}</a> 
		{foreachelse}
			<small>pas d'observateur précisé</small>
		{/foreach}
		<br/>
		{assign var='esp' value=$obs->get_espace()}
		{* https://github.com/picardie-nature/baseobs/issues/104 *}
		{assign var='departement' value=$esp->get_departement()}
		dans l'espace <b>{$obs->espace_table}.{$obs->id_espace}</b> {$esp->nom} <br/>
		{if $obs->espace_table == "espace_point"}
			{assign var='commune' value=$esp->get_commune()}
			dans la commune de <b>{$commune->nom}</b> ({$departement->nom})
		{/if} -
		<a class="btn btn-small" href="?t=observation_edit&id={$obs->id_observation}">(consulter/éditer observation)</a>
		<br/><br/>
	</li>
{foreachelse}
	<li><i>Aucune observation</i></li>
{/foreach}
</ul>

