{include file="header.tpl" container_fluid=1}
<div class="row-fluid">
	<div class="span3">
		<div class="well">
		{if $tag}<h3>Etiq. {$tag}</h3>{else}<h3>Étiquettes</h3>{/if}
		{if $tag}<a class="btn btn-info btn-small pull-right" href="?t=tags&root={$tag->parent_id}" id="tparent">remonter</a><br/>{/if}
		<ul class="nav nav-pills nav-stacked">
		{foreach from=$tags item=t name=btags}
			<li>
				<a href="?t=tags&root={$t.id_tag}">{$t.lib}({$t.ref})
					{if $t.a_chaine eq 't'}<span class="label label-success small">txt</span>{/if}
					{if $t.a_entier eq 't'}<span class="label label-success small">n</span>{/if}
				</a>
			</li>
		{foreachelse}
			<li><i><small>Vide</small></i></li>
		{/foreach}
		</ul>
		</div>
	</div>
	<div class="span6">
	{if $tag}
		<fieldset>
			<legend>Tag: {$tag->lib}</legend>
			<form method="post" action="?t=tags&root={$tag->id_tag}">
				<input type="hidden" name="action" value="maj"/>
				<input type="hidden" name="parent_id" value="{$tag->parent_id}"/>
				lib: <input type="text" name="lib" value="{$tag->lib}"/>
				ref: <input type="text" name="ref" value="{$tag->ref}"/><br/>
				<input type="checkbox" name="a_chaine" id="m_a_chaine" value="1" {if $tag->a_chaine}checked="1"{/if}/>
				<label for="m_a_chaine">peut avoir une chaine de caractère</label>
				<input type="checkbox" name="a_entier" id="m_a_entier" value="1" {if $tag->a_entier}checked="1"{/if}/>
				<label for="m_a_entier">peut avoir un entier</label>
				<input type="checkbox" name="categorie_simple" id="m_cat_simple" value="1" {if $tag->categorie_simple}checked="1"{/if}/>
				<label for="m_cat_simple">est une catégorie, ne peut être sélectionné</label><br/>
				classes esp ok : <input type="text" name="classes_esp_ok" value="{$tag->classes_esp_ok}"/>
				<input type="submit" value="Mettre à jour"/>
				a:{$tag->borne_a} b:{$tag->borne_b}
			</form>
			{if $tag->a_chaine}
				<h4>Différentes valeurs utilisées</h4>
				<h5>Sur les espaces</h5>
				<pre>{foreach from=$tag->get_v_text_values('espace_tags') item=txt}
{$txt.v_text}
{/foreach}</pre>
				<h5>Sur les citations</h5>
				<pre>{foreach from=$tag->get_v_text_values('citations_tags') item=txt}
{$txt.v_text} 
{/foreach}</pre>
				
			{/if}

		</fieldset>
		{/if}
	</div>
	<div class="span3">
		<div class="well">
		<form name="newtag" method="post" action="?t=tags">
			<b>Ajout d'un nouveau tag</b>
			<input type="hidden" name="action" value="nouveau">
			<input type="hidden" name="parent_id" value="{$root}">
			<p class="directive">Libellé</p>
			<p class="valeur"><input type="text" name="lib"></p>
			
			<p class="directive">Référence</p>
			<p class="valeur"><input type="text" name="ref"></p>
			
			<p class="directive">Permettre la saisie d'une chaîne de caractères</p>
			<p class="valeur"><input type="checkbox" name="a_chaine"></p>
			
			<p class="directive">Permettre la saisie d'un entier</p>
			<p class="valeur"><input type="checkbox" name="a_entier"></p>
			
			<p class="directive">Est simplement une catégorie<br/><small>(embranchement pas sélectionnable)</small></p>
			<p class="valeur"><input type="checkbox" name="categorie_simple"></p>

			<p class="valeur"><input type="submit" value="Enregistrer"></p>
		</form>
		</div>
	</div>
</div>
{include file="footer.tpl"}
