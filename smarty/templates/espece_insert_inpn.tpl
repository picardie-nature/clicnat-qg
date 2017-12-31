{include file="header.tpl"}
<form method="get" action="index.php">
	<input type="hidden" name="t" value="espece_insert_inpn"/>
	<div class="directive">
		Code INPN (CD_NOM ou CD_REF)
	</div>
	<div class="valeur">
		<input placeholder="cd_nom ou cd_ref" type="text" name="id" value="" id="inpn_f">
	</div>

	<div class="valeur">
		<input type="submit" value="Ajouter">
	</div>
</form>
<script>J('#inpn_f').focus();</script>
{include file="footer.tpl"}
