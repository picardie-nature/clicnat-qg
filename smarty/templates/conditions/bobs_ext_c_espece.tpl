Numéro ou nom de l'espèce :
<input type="text" id="rech_id_esp" name="id_espece" value=""/>
<input type="hidden" name="classe" value="bobs_ext_c_espece"/>
<script>
	{literal}
	J('#rech_id_esp').autocomplete({source:'?t=espece_autocomplete2&nohtml=1'});
	{/literal}
</script>

