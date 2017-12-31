{include file="header.tpl"}
<h1>Suppression d'une espèce</h1>
<ul>
    <li>
	<a href="?t=espece_supprimer&id={$esp->id_espece}&confirm=1">
	    Confirmer la suppression de <b>{$esp}</b>
	</a>
    </li>
    <li>
	<a href="?t=espece_detail&id={$esp->id_espece}">
	    Retourner sur la fiche
	</a>
    </li>
</ul>
{include file="footer.tpl"}
