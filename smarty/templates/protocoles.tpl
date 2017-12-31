{include file="header.tpl" container_fluid="1"}
{include file="footer.tpl"}
<div class="row-fluid">
	<div class="span4">
		<div class="well">
		<form method="post" action="?t=protocoles&action=ajouter">
			<input type="text" name="id_protocole" placeholder="identifiant (wetlands2013)" required="true"/><br/>
			<input type="text" name="lib" placeholder="libellé" required="true"/><br/>
			<button>Créer</button>
		</form>
		</div>
		<ul class="nav nav-pills nav-stacked">
		{foreach from=$protocoles item=p}
			<li class="{if $protocole}{if $protocole->id_protocole eq $p->id_protocole}active{/if}{/if}"><a href="?t=protocoles&id={$p->id_protocole}">{$p}</a></li>
		{/foreach}
		</ul>
	</div>
	<div class="span8">
		{if $protocole}
		<form method="post" action="?t=protocoles&action=maj">
			<input type="hidden" name="id" value="{$protocole->id_protocole}">
			<div class="form-group">
				<label for="_lib">Libellé</label>
				<input id="_lib" type="text" style="width:80%;" name="lib" value="{$protocole->lib}">
			</div>
			<div class="form-group">
				<label>Description</label>
				<textarea name="description" style="width:80%;">{$protocole->description}</textarea>
			</div>
			<div class="form-group">
				<label>Actif</label>
				{include file="__select_bool.tpl" champ="ouvert" valeur=$protocole->ouvert}
			</div>
			<input type="submit" class="btn btn-primary" value="Modifier"/>
		</form>
		{/if}
	</div>
</div>
{include file="footer.tpl"}
