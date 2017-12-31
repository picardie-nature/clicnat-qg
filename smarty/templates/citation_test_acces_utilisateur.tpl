Résultat :
<ul>
{if $citation_ok}
	<li>{$utilisateur} peut voir la citation</li>
{else}
	<li style="color:red;">{$utilisateur} peut pas voir la citation</li>
{/if}
{if $citation->autorise_validation($utilisateur->id_utilisateur)}
	<li>{$utilisateur} peut intervenir sur la validation</li>
{else}
	<li style="color:red;">{$utilisateur} ne peut pas valider</li>
{/if}
{if $citation->autorise_modification($utilisateur->id_utilisateur)}
	<li>{$utilisateur} peut modifier la donnée</li>
{else}
	<li style="color:red;">{$utilisateur} ne peut pas modifier la donnée</li>
{/if}
</ul>
	
