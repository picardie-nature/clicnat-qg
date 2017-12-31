<ul>
{foreach from=$espece->tags_utilisees() item=tag}
	<li>{$tag.lib} <small><small>#{$tag.id_tag}</small></small></li>
{/foreach}
</ul>
