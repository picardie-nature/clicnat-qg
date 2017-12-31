{include file="header.tpl"}
{if $auth_ok}
<table class="table table-bordered table-striped">
	<tr>
		<th>#</th>
		<th>Date création</th>
		<th>Sélection</th>
		<th>Actions</th>
	</tr>
	{foreach from=$utl->selections() item=s}
	<tr>
		<td>{$s->id_selection}</td>
		<td>{$s->date_creation|date_format:"%d-%m-%Y"}</td>
		<td>{$s->nom_selection}</td>
		<td>
			<div class="btn-group">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="#">Actions <span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li><a href="?t=selection&id={$s->id_selection}">Voir les données</a></li>
					<li><a href="?t=selection_info&id={$s->id_selection}">Informations</a></li>
					<li><a href="?t=selection_csv&id={$s->id_selection}">Télécharger CSV</a></li>
				</ul>
			</div>
		</td>
	</tr>
	{/foreach}
</table>
{/if}
{include file="footer.tpl"}
