{include file="header.tpl"}
<div class="row">
	<div class="span12">
		<h1>Mes sélections</h1>
		<table class="table table-striped">
		    <tr>
		      <th>Sélection</th>
		      <th>#</th>
		    </tr>
		    {foreach from=$mes_selections item=ms}
		    <tr>
		       <td> {$ms->nom_selection} </td>
		       <td>
		    	<div class="btn-group">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="#"> Actions <span class="caret"></span></a> 
				<ul class="dropdown-menu">
					<li><a href="?t=selection&id={$ms->id_selection}">Voir les données</a></li>
					<li><a href="?t=selection_info&id={$ms->id_selection}">Informations</a></li>
					<li><a href="?t=selection_csv&id={$ms->id_selection}">Télécharger CSV</a></li>
				</ul>
			</div>
		       </td>
		    </li>
		    {/foreach}
		 </table>
	</div>
</div>
<div class="row">
	<div class="span6">
		<h1>Liste des sélections du QG</h1>
		<table>
		    <tr>
			<th>Sélection</th>
			<th>Propriétaire</th>
			<th></th>
		    </tr>
		{foreach from=$selections_qg item=s}
		    <tr>
			<td>{$s.nom_selection}</td>
			<td>{$s.proprietaire}</td>
			<td>
			    <a href="?t=selection&id={$s.id_selection}">voir</a> -
			    <a href="?t=selection_info&id={$s.id_selection}">infos</a> -
			    <a href="?t=selection_csv&id={$s.id_selection}">csv</a>
			</td>
		    </tr>
		{/foreach}
		</table>
	</div>
</div>
{include file="footer.tpl"}
