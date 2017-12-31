<table width="100%">
	    <tr>
		<th>Ligne</th>
		<th>Obs.</th>
		<th>Espace</th>
		<th></th>
	    </tr>
	{foreach from=$import->get_observations() item=obs}
	    <tr>
		<td>{$obs->num_ligne} {$this->n_ligne}</td>
		<td>{$obs->id_observation}</td>
		<td>{$obs->id_espace}</td>
		<td><a href="javascript:import_editer_obs({$import->id_import}, {$obs->id_observation});">Éditer</a></td>
	    </tr>
	{/foreach}
</table>
