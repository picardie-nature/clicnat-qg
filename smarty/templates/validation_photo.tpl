{include file="header.tpl"}
<script src="js/jquery.Jcrop.min.js"></script>
<link rel="stylesheet" href="css/jquery.Jcrop.css" type="text/css" />
<div style="display:none;">
	<div id="recadrer" title="Recadrer une photo">
		<img id="cropim" src="">
	</div>
</div>
{literal}
<style>
	.ui-widget { font-size: 0.8em; }
</style>
<script language="Javascript">
	var recadr = false;
	var doc_id = false;
	var largeur_travail = 600;

	function sauver_recadrage(r)
	{
		recadr = r;
	}

	function faire_recadrage()
	{
		if (recadr) {
			log(recadr);
			recadr['doc_id'] = doc_id;
			recadr['largeur_travail'] = largeur_travail;
			recadr['t'] = 'validation_photo';
			recadr['redim'] = '1';
			document.location.href = '?'+J.param(recadr);
		} else {
			alert('Pas de nouveau cadre');
		}

	}

	function recadrer(p_doc_id)
	{
		doc_id = p_doc_id;
		document.getElementById('cropim').src = '?t=img&w='+largeur_travail+'&id='+doc_id;
		J('#recadrer').dialog({width:800, height:600, buttons: {Recadrer: faire_recadrage}});
		J('#cropim').Jcrop({aspectRatio: 4/3, onSelect: sauver_recadrage});
	}

	function vp_init()
	{
		J('.b_recadre').button();
	}

	J().ready(vp_init);
</script>
{/literal}
<h1>Photographie en attente de validation</h1>

{if !$ordre}
	{if !$classe}
		<ul>
		{foreach from=$classes item=c key=id_c}
			<li><a href="?t=validation_photo&classe={$id_c}">{$c.lib} {$c.n}</a></li>
		{/foreach}
		</ul>
	{else}
		<a href="?t=validation_photo&classe=">{$classe}</a>
		<ul>
		{foreach from=$ordres item=n key=o}
			<li><a href="?t=validation_photo&ordre={$o}">{$o} {$n}</a></li>
		{/foreach}
		</ul>
	{/if}
{else}
	{$classe}/<a href="?t=validation_photo&ordre=">{$ordre}</a>
	<table>
	{foreach from=$liste item=d}
	{assign var=e value=$d->get_doc_espece()}
	{if $e}
	  {if $e->classe == $classe}
	    {if $e->ordre == $ordre}
	<tr>
		<td valign="top">
			{if $d->get_type() == 'image'}
				<a href="?t=img&id={$d->get_doc_id()}" target="_blank">
					<img src="?t=img&w=200&id={$d->get_doc_id()}"/>
				</a>

			{elseif $d->get_type() == 'audio'}
				<object type="application/x-shockwave-flash" data="swf/player_mp3_mini.swf" width="200" height="20">
					<param name="movie" value="player_mp3_mini.swf" />
					<param name="bgcolor" value="#C6E548" />
					<param name="FlashVars" value="mp3=%3Ft%3Daudio%26id%3D{$d->get_doc_id()}" />
				</object>
			{/if}
		</td>
		<td valign="top">
			{if $d->get_type() == 'image'}
				Cette photo doit représenter <b>{$e->nom_f} <i>{$e->nom_s}</i></b><br/>
				Auteur de la photo : <b>{$d->get_auteur()}</b>
				<ul>
					<li><a href="?t=validation_photo&accept={$d->get_doc_id()}">Accepter et ajouter la photo</a></li>
					<li><a href="?t=validation_photo&reject={$d->get_doc_id()}">Rejeter cette photo</a></li>
					{if $d->a_un_backup()}
					<li><a href="?t=validation_photo&restore={$d->get_doc_id()}">Restaurer document original</a></li>
					{/if}
				</ul>
				{if $d->quatre_tiers()}<font color="green">4/3</font>{else}<font color="red">4/3</font>{/if}
				<button class="b_recadre" id="r{$d->get_doc_id()}">Recadrer</button>
				<script>J('#r{$d->get_doc_id()}').click(function () 
				{literal}{{/literal}
					recadrer('{$d->get_doc_id()}'); 
				{literal}}{/literal}
				);</script>
			{elseif $d->get_type() == 'audio'}
				Fichier audio
				Ce fichier audio doit représenter <b>{$e->nom_f} <i>{$e->nom_s}</i></b><br/>
				Auteur : <b>{$d->get_auteur()}</b>
				<ul>
					<li><a href="?t=validation_photo&accept={$d->get_doc_id()}">Accepter et ajouter la photo</a></li>
					<li><a href="?t=validation_photo&reject={$d->get_doc_id()}">Rejeter cette photo</a></li>
				</ul>
			{else}
				Type de document inconnu {$d->get_type()}
			{/if}
		</td>
	</tr>
	   {/if}
	  {/if}
	{/if}
	{foreachelse}
	<tr><td colspan=2>Pas de photo en attente de validation</td></tr>
	{/foreach}
	</table>
{/if}
{include file="footer.tpl"}
