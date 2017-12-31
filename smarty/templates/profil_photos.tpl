{include file="header.tpl" container_fluid=1}
{assign var=docs value=$u->get_obs_docs()}
<div>
{$docs|@count} Photos associées aux observations de {$u}
</div>
{foreach from=$docs item=doc}
	{doc var=obj_doc id=$doc.document_ref}
	{if $obj_doc->get_type() eq 'image'}
	{assign var=dims value=$obj_doc->redims_dim(0,320)}
	<div style="float:left; width:{$dims[0]}px; margin:4px; padding:0px; color: white; background-color: black; position:relative;">
		<div style="width:{$dims[0]}px; height:{$dims[1]}px; background-color: #eee;">
			<div style="position:absolute;display:inline; top:0px; width:{$dims[0]}px; z-index:10; background-color: black;">
				<div style="padding:3px;">{$doc.date_observation|date_format:"%d-%m-%Y"} - {$doc.nom_f} <i>{$doc.nom_s}</i></div>
			</div>
			<div style="position:absolute;display:inline; top:300px; width:{$dims[0]}px; z-index:12; vertical-align:center;">
			</div>
			<div style="position:absolute;display:inline; top:0px; height:{$dims[1]}px; width:{$dims[0]}px; z-index:1;">
				<a href="?t=img&id={$doc.document_ref}">
					<img class="lazy" src="" data-original="?t=img&id={$doc.document_ref}&h=320"/>
				</a>
			</div>
		</div>
		<div style="clear:both;"></div>
	</div>
	{/if}
{/foreach}
{include file="footer.tpl"}
