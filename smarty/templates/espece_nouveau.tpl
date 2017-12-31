{include file="header.tpl"}
<h1>Ajout d'une espèce</h1>
<form name="espece" method="post" action="?t=espece_nouveau&saveme=1">
	<div class="directive">Classe</div>
	<div class="valeur">
		<select name="classe">
		{foreach from=$menu_classes item=classe key=k}
			<option value="{$k}">{$classe}</option>
		{/foreach}
		</select>
	</div>

	<div class="directive">Code espèce</div>
	<div class="valeur"><input type="text" name="espece"></div>

	<div class="directive">Type de fiche</div>
	<div class="valeur"><input type="text" name="type_fiche"></div>

	<div class="directive">Systématique</div>
	<div class="valeur"><input type="text" name="systematique"></div>

	<div class="directive">Ordre</div>
	<div class="valeur"><input type="text" name="ordre"></div>

	<div class="directive">Commentaire</div>
	<div class="valeur"><input type="text" name="commentaire"></div>

	<div class="directive">Famille</div>
	<div class="valeur"><input type="text" name="famille"></div>

	<div class="directive">Nom français</div>
	<div class="valeur"><input type="text" name="nom_f"></div>

	<div class="directive">Nom scientifique</div>
	<div class="valeur"><input type="text" name="nom_s"></div>

	<div class="directive">Nom anglais</div>
	<div class="valeur"><input type="text" name="nom_a"></div>

	<div class="valeur"><input type="submit" value="Enregistrer"></div>
</form>
<a href="?t=espece_insert_inpn">Ajouter à partir d'un numéro de référence du MNHN</a>
{include file="footer.tpl"}
