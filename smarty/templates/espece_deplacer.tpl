{include file="header.tpl"}
<h1>Déplacement des citations de cette espèce</h1>

{if $etape == 1}
<h2>Choix de la nouvelle espèce</h2>
<form method="post" action="?t=espece_deplacer&id={$orig->id_espece}">
    Actuellement : {$orig} <small>({$orig->id_espece})</small><br/>
    <input type="text" name="id_destination" value=""/>
    <input type="submit" value="Vérifier"/>
</form>
{/if}

{if $etape == 2}
<h2>Confirmer remplacement</h2>
<div class="directive">Les citations de</div>
<div class="valeur">{$orig} <small>{$orig->id_espece}</small></div>

<div class="directive">seront déplacées sur</div>
<div class="valeur">{$dest} <small>{$dest->id_espece}</small></div>

<div class="valeur">
    <form method="post" action="?t=espece_deplacer&id={$orig->id_espece}">
	<input type="hidden" name="id_destination" value="{$dest->id_espece}"/>
	<input type="hidden" name="confirmation" value="1"/>
	<input type="submit" value="Je sais ce que je fais et je le confirme"/>
    </form>
    <form method="get" action="">
	<input type="hidden" name="t" value="espece_detail"/>
	<input type="hidden" name="id" value="{$orig->id_espece}"/>
	<input type="submit" value="Je retourne sur la fiche sans rien modifier"/>
    </form>
</div>
{/if}

{if $etape == 3}
<h2>Déplacement terminé</h2>
Toutes les citations ont été déplacées<br/>
<ul>
    <li><a href="?t=espece_detail&id={$orig->id_espece}">Espèce de départ : {$orig}</a></li>
    <li><a href="?t=espece_detail&id={$dest->id_espece}">Espèce d'arrivée : {$dest}</a></li>
</ul>
{/if}
{include file="footer.tpl"}