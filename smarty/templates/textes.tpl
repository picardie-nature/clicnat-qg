{include file="header.tpl" container_fluid="1"}
<div class="row-fluid">
	<div class="span4">
		<div class="well">
		<form method="post" action="?t=textes">
			<input type="text" name="nouveau_nom" placeholder="nouveau texte"/><br/>
			<button>Créer</button>
		</form>
		</div>

		<ul class="nav nav-pills nav-stacked">
		{foreach from=$textes item=t}
			<li class="{if $texte}{if $texte->id_texte eq $t->id_texte}active{/if}{/if}"><a href="?t=textes&id={$t->id_texte}">{$t->nom}</a></li>
		{/foreach}
		</ul>
	</div>
	<div class="span8">
		{if $texte}
		<form method="post" action="?t=textes&id={$texte->id_texte}">
			<h2>{$texte}</h2>
			<small><a target="_blank" href="http://michelf.ca/projets/php-markdown/concepts/">aide pour la syntaxe</a></small>
			<textarea style="width:100%;" rows="18" name="texte">{$texte->texte}</textarea>
			<input type="submit" value="mettre à jour">
		</form>
		<h3>Aperçu</h3>
		<div class="well">{$texte->texte|markdown}</div>
		{/if}
	</div>
</div>
{include file="footer.tpl"}
