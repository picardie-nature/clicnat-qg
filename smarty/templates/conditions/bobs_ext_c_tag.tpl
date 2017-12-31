Choisir un code dans cette liste :
<select id="s_id_tag">
	<option></option>
	<option value="579">En attente de validation</option>
	<option value="580">En attente d'homologation</option>
	<option value="591">Invalide</option>
	<option value="592">Nouvel observateur</option>

	<option value="372">Rassemblements</option>
	<option value="375">Rassemblements en harde</option>
	<option value="211">Halte migratoire</option>
	
	<option value="168">Posé</option>
	<option value="322">Se pose</option>
	<option value="170">Posé en groupe</option>
	<option value="179">Posé dans un champ</option>
	
	<option value="99">Chant</option>
</select><br/>
ou chercher ici :
<input type="text" id="r_id_tag"/>
<br/><hr/><br/>
<input size="5" type="text" id="id_tag" name="id_tag" value=""/>
<input type="hidden" name="classe" value="bobs_ext_c_tag"/>
<script>
{literal}
J('#s_id_tag').change(function () { 
	console.log(J(this).val());
	J('#id_tag').val(J(this).val());
});
J('#r_id_tag').autocomplete({
	source: 'index.php?'+J.param({t: 'tag_citations_autocomplete'}),
	select: function (event, ui) {
		J('#id_tag').val(ui.item.id);
	}
});
{/literal}
</script>

