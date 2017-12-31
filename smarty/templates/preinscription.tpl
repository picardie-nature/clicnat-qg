{include file="header.tpl"}
<h1>État des inscriptions</h1>
<p>Ces personnes ont rempli le formulaire d'inscription mais pas encore confirmé</p>
<table>
	<tr>
		<th>Nom</th>
		<th>Prénom</th>
		<th>Mail</th>
		<th></td>
	</tr>
{foreach from=$preinscriptions item=p}
	<tr>
		<td>{$p->nom}</td>
		<td>{$p->prenom}</td>
		<td>{$p->email}</td>
		<td><a href="?t=preinscription&s={$p->suivi}">annuler</a></td>
	</tr>
{/foreach}
</table>
<h1>Derniers inscrits</h1>
<table>
	<tr>
		<th>Nom</th>
		<th>Prénom</th>
		<th>Mail</th>
		<th></th>
	</tr>
{foreach from=$derniers item=p}
	<tr>
		<td>{$p->nom}</td>
		<td>{$p->prenom}</td>
		<td>{$p->mail}</td>
		<td><a href="?t=profil&id={$p->id_utilisateur}">voir</a></td>
	</tr>
{/foreach}
</table>
{include file="footer.tpl"}
