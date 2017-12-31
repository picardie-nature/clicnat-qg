{include file="header.tpl"}
<h1>Interface chiro</h1>
<fieldset>
	<legend>Réunion de gîtes</legend>
	<form method="get" action="index.php">
		<input type="hidden" name="t" value="chiros"/>
		Gîte A : <input type="text" name="cavite_a" value="{$ca}"/><br/>
		Gîte B : <input type="text" name="cavite_b" value="{$cb}"/><br/>
		<input type="submit" value="Enregistrer"/>
	</form>
	{if $ca} 
	{if !$ca->a_des_observations()}
		<p>Pas d'observation dans le gîte de départ</p>
	{/if}
	<form method="get" action="index.php">
		<input type="hidden" name="t" value="chiros"/>
		<input type="hidden" name="a" value="deplacer"/>
		<input type="hidden" name="gite_a" value="{$ca->id_espace}"/>
		<input type="hidden" name="gite_b" value="{$cb->id_espace}"/>
		<input type="submit" value="Déplacer les données de {$ca} dans {$cb}"/>
		<input type="checkbox" name="suppr" value="1" id="bsuppr"/><label for="bsuppr">et supprimer {$ca} après</label>
	</form>
	{/if}
</fieldset>
<fieldset>
	<legend>Supprimer un gîte</legend>
	<form method="get" action="index.php">
		<input type="hidden" name="t" value="chiros"/>
		<input type="hidden" name="a" value="supprimer"/>
		<input type="text" name="cavite" value="{$c}"><br/>
		<input type="submit" value="Supprimer le gîte"/>
	</form>
	{if $c}
	{if !preg_match("^P_",$c)}
		<p><font color="red">Seul les cavités P_ peuvent être supprimées</font></p>
	
	{elseif $c->a_des_observations()}
		<p><font color="red">Il y'des observations dans la cavité, suppression impossible</font></p>
	
	{else}
	<form method="get" action="index.php">
		<input type="hidden" name="t" value="chiros"/>
		<input type="hidden" name="a" value="supprimer"/>
		<input type="hidden" name="cavite" value="{$c->id_espace}"><br/>
		<input type="submit" value="Confirmer la suppression de {$c}"/>
	</form>
	{/if}
	{/if}
</fieldset>
<fieldset>
	<legend>Remise à zéro des gîtes a prospecter</legend>
	<form method="get" action="index.php">
		<input type="hidden" name="t" value="chiros"/>
		<input type="hidden" name="a" value="raz_prospect"/>
		<input type="checkbox" name="confirm" value="1">Cocher pour confirmer la remise a zéro<br/>
		<input type="submit" value="Remettre a zéro la liste des gîtes a prospecter"/>
	</form>
</fieldset>
{include file="footer.tpl"}
