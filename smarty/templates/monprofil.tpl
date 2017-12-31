{include file="header.tpl"}
{if $auth_ok}
<h1>Mon profil</h1>

<p class="directive">Nom</p>
<p class="valeur">{$u->nom}</p>

<p class="directive">Pr&eacute;nom</p>
<p class="valeur">{$u->prenom}</p>

<p class="directive">Nom d'utilisateur</p>
<p class="valeur">{$u->username}</p>

<p class="directive">T&eacute;l&eacute;phone</p>
<p class="valeur">{$u->tel}</p>

<p class="directive">T&eacute;l&eacute;phone portable</p>
<p class="valeur">{$u->port}</p>

<p class="directive">Fax</p>
<p class="valeur">{$u->fax}</p>

<p class="directive">Adresse email</p>
<p class="valeur">{$u->mail}</p>
{/if}
{include file="footer.tpl"}
