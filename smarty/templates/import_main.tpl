{include file="header.tpl"}
<script>
    var id_import = {$import->id_import};
</script>
{literal}
<script>
function def_set()
{
    var c = J('#colonne').val();
    var t = J('#type').val();
    url = '?t=import_set_col_type&id_import='+id_import+'&colonne='+c+'&type='+t;
    J('#'+c).load(url);
    J('#def_diag').dialog('close');
}

function def_diag(colonne)
{
    J('#colonne').val(colonne);
    J('#def_diag').dialog({modal: true, buttons: { 'Enregistrer': def_set }});
}

function test_colonnes()
{
    J('#test_diag').dialog({modal: true, height: 400});
    J('#test_diag').load('?t=import_test_cols&id='+id_import);
}
</script>
{/literal}
<h1>Définition des colonnes</h1>
<div style="display:none;">
    <div title="Choix du type de la colonne" id="def_diag">
	<p class="valeur">
	    Colonne : <input type="text" size="11" value="colonne" id="colonne" disabled="true"/><br/>
	    Type : <select id="type" name="type">
		<option value=""></option>
		{foreach from=$types item=type}
		    <option value="{$type}">{$import->titre_type_colonne($type)}</option>
		{/foreach}
	    </select>
	</p>
    </div>
    <div id="test_diag" title="Test des colonnes sur les autres lignes">
	Test en cours
    </div>
</div>
<div style="float:right;">
    <input type="button" value="tester les colonnes sur les autres lignes" onclick="javascript:test_colonnes()"/>
    <form method="get">
	<input type="hidden" name="t" value="import_main"/>
	<input type="hidden" name="id" value="{$import->id_import}"/>
	<input type="hidden" name="valeurs_par_defaut" value="1"/>
	<input type="submit" value="définir les valeurs par défaut"/>
    </form>
</div>
<table>
	<tr>
		<th>Colonne</th>
		<th>Échantillon</th>
		<th>Programme</th>
	</tr>
	{foreach from=$colonnes item=colonne}
	<tr>
		<td>{$colonne}</td>
		<td>{$ligne.$colonne}</td>
		<td>
		    <div id="{$colonne}">{$import->titre_type_colonne($import->get_colonne_type($colonne))}</div>
		    <input type="button" value="def" onclick="javascript:def_diag('{$colonne}');"/>
		</td>
	</tr>
	{/foreach}
</table>
{include file="footer.tpl"}
