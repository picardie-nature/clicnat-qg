{include file="header.tpl"}
{if $auth_ok}
<h1>Modification d'un observateur</h1>
<a href="?t=profil&id={$u->id_utilisateur}">Retourner sur la fiche de l'observateur</a>
<form method="post" action="index.php?t=observateur_modifier">
	<input type="hidden" name="doModif" value="1"/>
	<input type="hidden" name="id_utilisateur" value="{$u->id_utilisateur}"/>
	<p class="directive">Nom</p>
	<p class="valeur"><input type="text" name="nom" value="{$u->nom}" id="focus">

	<p class="directive">Pr&eacute;nom</p>
	<p class="valeur"><input type="text" name="prenom" value="{$u->prenom}"></p>

	<p class="directive">Date de naissance</p>
	<p class="valeur"><input type="text" name="date_naissance" value="{if $u->date_naissance}{$u->date_naissance|date_format:"%d-%m-%Y"}{/if}"></p>

	
	<p class="directive">Nom de connection</p>
	<p class="valeur">
		<input type="text" name="username" value="{$u->username}">
		-
		<a href="javascript:;" onclick="javascript:verif_login();">V&eacute;rifier la disponibilit&eacute;e du nom</a>
	</p>

	<p class="directive">Mot de passe</p>
	<p class="valeur"><input type="password" name="pwd1"> - <input type="password" name="pwd2"></p>

	<p class="directive">Num&eacute;ro de t&eacute;l&eacute;phone</p>
	<p class="valeur"><input type="text" name="tel" value="{$u->tel}"></p>

	<p class="directive">Num&eacute;ro de t&eacute;l&eacute;phone portable</p>
	<p class="valeur"><input type="text" name="port" value="{$u->port}"></p>

	<p class="directive">Adresse email</p>
	<p class="valeur"><input type="text" name="mail" value="{$u->mail}"></p>

	<p class="directive">Accès a l'interface 'QG'</p>
	<p class="valeur"><input type="checkbox" value="t" name="acces_qg" {if $u->acces_qg == 't'}checked{/if}></p>

	<p class="directive">Accès a l'interface 'Poste'</p>
	<p class="valeur"><input type="checkbox" value="t" name="acces_poste" {if $u->acces_poste == 't'}checked{/if}></p>

	<p class="directive">Accès a l'interface 'Chiros'</p>
	<p class="valeur"><input type="checkbox" value="t" name="acces_chiros" {if $u->acces_chiros== 't'}checked{/if}></p>

	<p class="directive">Diffusion restreinte</p>
	<p class="valeur"><input type="checkbox" value="t" name="diffusion_restreinte" {if $u->diffusion_restreinte == true}checked{/if}></p>

	<p class="directive"><input type="submit" value="Modifier le compte"/></p>
	<div class="directive">Identifiant CSNP</div>
	<div class="valeur"><input type="text" name="id_csnp" value="{$u->id_csnp}"/></div>
</form>
<script>document.getElementById('focus').focus();</script>
{/if}
{include file="footer.tpl"}
