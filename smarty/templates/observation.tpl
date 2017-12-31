{include file="header.tpl"}
<div class="directive">Numéro</div>
<div class="valeur">{$obs->id_observation}</div>

<div class="directive">Observateurs</div>
{foreach from=$obs->get_observateurs() item=observ}
	<div class="valeur"><a href="?t=profil&id={$observ.id_utilisateur}">{$observ.nom} {$observ.prenom}</a></div>
{foreachelse}
	<small>pas d'observateur précisé</small>
{/foreach}
{include file="footer.tpl"}
