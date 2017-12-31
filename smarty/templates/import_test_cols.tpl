Lignes avec des colonnes non gérées :
<ul>
{foreach from=$t item=e}
    <li><a href="?t=import_main&id={$import->id_import}&ligne={$e}">ligne {$e}</a></li>
{foreachelse}
    <li>Toutes les colonnes sont gérées : <a href="?t=import_obs&id={$import->id_import}">passer à la création des observations &rArr;SCAN</a></li>
{/foreach}

</ul>