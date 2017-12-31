{if !$espece->referentiel_regionale_existe()}
	<div class="info"><p>Il n'existe pas d'informations enregistrées pour cette espèce</p></div>
{/if}

{if $oldref}
	<div class="info"><p>Vous pouvez utiliser les valeurs de l'import du référentiel picardie-nature</p></div>
{/if}

<div align="right">
	<input type="button" value="Mettre à jour" onClick="javascript:enregistre_referentiel();"/>
</div>

<form id="edrr" action="?t=espece_details_referentiel_region&id={$espece->id_espece}">
	<div class="directive">Statut d'origine</div>
	<div class="valeur">
		<select name="statut_origine">
			<option value=""></option>
			{foreach from=$espece->liste_statut_origine() item=i}
				<option value="{$i}" {if $ref_region.statut_origine == $i}selected{/if}>{$i}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->statut_org}</small>{/if}
	</div>
	<div class="directive">Statut biologique</div>
	<div class="valeur">
		<select name="statut_bio">
			<option value=""></option>
			{foreach from=$espece->liste_statut_bio() item=i}
				<option value="{$i}" {if $ref_region.statut_bio == $i}selected{/if}>{$i}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->statut_bio}</small>{/if}
	</div>
	<div class="directive">Indice de rareté</div>
	<div class="valeur">
		<select name="indice_rar">
			<option value=""></option>
			{foreach from=$espece->liste_indice_rar() item=i}
				<option value="{$i}" {if $ref_region.indice_rar == $i}selected{/if}>{$i} {$espece->get_indice_rar_lib($i)}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->indice_rar}</small>{/if}
	</div>
	<div class="directive">Niveau de conservation</div>
	<div class="valeur">
		<select name="niveau_con">
			<option value=""></option>
			{foreach from=$espece->liste_niveau_conservation() item=i}
				<option value="{$i}" {if $ref_region.niveau_con == $i}selected{/if}>{$i}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->niveau_con}</small>{/if}
	</div>
	<div class="directive">Degré de menace</div>
	<div class="valeur">
		<select name="categorie">
			<option value=""></option>
			{foreach from=$espece->liste_degre_menace() item=i}
				<option value="{$i}" {if $ref_region.categorie == $i}selected{/if}>{$i} {$espece->get_degre_menace_lib($i)}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->categorie}</small>{/if}
	</div>
	<div class="directive">Fiabilité</div>
	<div class="valeur">
		<select name="fiabilite">
			<option value=""></option>
			{foreach from=$espece->liste_fiabilite() item=i}
				<option value="{$i}" {if $ref_region.fiabilite == $i}selected{/if}>{$i}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->fiabilite}</small>{/if}
	</div>
	<div class="directive">État de conservation</div>
	<div class="valeur">
		<select name="etat_conv">
			<option value=""></option>
			{foreach from=$espece->liste_etat_conservation() item=i}
				<option value="{$i}" {if $ref_region.etat_conv == $i}selected{/if}>{$i}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->prot_etat_conv_reg}</small>{/if}
	</div>

	<div class="directive">Priorité de conservation</div>
	<div class="valeur">
		<select name="prio_conv_cat">
			<option value=""></option>
			{foreach from=$espece->liste_priorite_conservation() item=i}
				<option value="{$i}" {if $ref_region.prio_conv_cat == $i}selected{/if}>{$i}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->prot_prio_conserv_cat}</small>{/if}
	</div>

	<div class="directive">Fiabilité priorité de conservation</div>
	<div class="valeur">
		<select name="prio_conv_fia">
			<option value=""></option>
			{foreach from=$espece->liste_fiabilite_prio_conservation() item=i}
				<option value="{$i}" {if $ref_region.prio_conv_fia == $i}selected{/if}>{$i}</option>
			{/foreach}
		</select>
		{if $oldref}<small>{$oldref->prot_prio_conserv_fia}</small>{/if}
	</div>
</form>

<div align="right">
	<input type="button" value="Mettre à jour" onClick="javascript:enregistre_referentiel();"/>
</div>
