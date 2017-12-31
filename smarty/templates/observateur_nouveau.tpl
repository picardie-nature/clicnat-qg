{include file="header.tpl"}
<h1>Cr&eacute;ation d'un nouvel observateur</h1>
<form method="post" action="index.php?t=observateur_nouveau">
	<p class="directive">Nom</p>
	<p class="valeur"><input type="text" name="nom" value="{$nom}" id="focus">

	<p class="directive">Pr&eacute;nom</p>
	<p class="valeur"><input type="text" name="prenom" value="{$prenom}"></p>
	
	<p class="directive">Nom de connection</p>
	<p class="valeur">
		<input type="text" name="username" value="{$username}">
		-
		<a href="javascript:;" onclick="javascript:verif_login();">V&eacute;rifier la disponibilit&eacute;e du nom</a>
	</p>

	<p class="directive">Mot de passe</p>
	<p class="valeur"><input type="password" name="pwd1" value="{$pwd1}"> - <input type="password" name="pwd2" value="{$pwd2}"></p>

	<p class="directive">Num&eacute;ro de t&eacute;l&eacute;phone</p>
	<p class="valeur"><input type="text" name="tel" value="{$tel}"></p>

	<p class="directive">Num&eacute;ro de t&eacute;l&eacute;phone portable</p>
	<p class="valeur"><input type="text" name="port" value="{$port}"></p>

	<p class="directive">Adresse email</p>
	<p class="valeur"><input type="text" name="mail" value="{$mail}"></p>

	<p class="directive"><input type="submit" value="Cr&eacute;er le nouveau compte"/></p>
</form>
<script>document.getElementById('focus').focus();</script>
{include file="footer.tpl"}
