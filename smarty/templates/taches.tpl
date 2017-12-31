{include file="header.tpl" container_fluid="1"}
<div class="row-fluid">
	<div class="span4">
		<div class="well">
			<h3>Taches planifiées {$planif->count()}</h3>
			<ul>
			{foreach from=$planif item=tache}
				<li>
					<a href="?t=taches&id={$tache->id_tache}">{$tache}</a>
					<div style="float:right;">
						<a href="?t=taches&id={$tache->id_tache}&modif=exec_maintenant">Exec</a>
						<a href="?t=taches&id={$tache->id_tache}&modif=annuler">Annuler</a>
					</div>
				</li>
			{/foreach}
			</ul>
			<h3>Taches en attente {$en_attente->count()}</h3>
			<ul>
			{foreach from=$en_attente item=tache}
				<li><a href="?t=taches&id={$tache->id_tache}">{$tache}</a></li>
			{/foreach}
			</ul>
			<h3>Taches en cours {$en_cours->count()}</h3>
			<ul>
			{foreach from=$en_cours item=tache}
				<li><a href="?t=taches&id={$tache->id_tache}">{$tache}</a></li>
			{/foreach}
			</ul>
			<h3>Taches terminées</h3>
			<ul>
			{foreach from=$terminees item=tache}
				<li>
					<a href="?t=taches&id={$tache->id_tache}" {if $tache->code_retour gt 0}class="text-error"{/if}>
						{$tache}
						<div class="pull-right"><span class="glyphicon glyphicon-user"></span> {$tache->utilisateur()}</div>
						<div class="clearfix"></div>
					</a>
				</li>
			{/foreach}
			</ul>
		</div>
	</div>
	<div class="span8">
	 {if $tache_sel}
	 	<h1>{$tache_sel}</h1>
		<ul>
			<li>Tache créée le {$tache_sel->date_creation|date_format:"%d-%m-%Y à %H:%M:%S"} pour {$tache_sel->utilisateur()} exécution prévue pour le {$tache_sel->date_exec_prevue|date_format:"%d-%m-%Y à %H:%M:%S"}</li>
			<li>Classe : {$tache_sel->classe}</li>
			<li>Paramètres : {$tache_sel->args}</li>
			{if $tache_sel->date_exec}
				<li>Tache lancée le : 
					<b>{$tache_sel->date_exec|date_format:"%d-%m-%Y à %H:%M:%S"}</b>
					{if $tache_sel->date_fin}
						et terminée le 
						<b>{$tache_sel->date_fin|date_format:"%d-%m-%Y à %H:%M:%S"}</b>
					{/if}
				</li>
				<li>
					Résultat : {$tache_sel->code_retour} (0 ok, 1 erreur, 2 annulé)
					<pre>{$tache_sel->message_retour}</pre>
				</li>
			{/if}
		</ul>
	 {else}
	 	<h1>Créer une tache</h1>
		<ul>
			<li><a href="?t=taches&creer_tache=bornes_especes">Mise à jour du bornage de l'arbre taxo (a utiliser après création d'un complexe par exemple)</a></li>
			<li><a href="?t=taches&creer_tache=mad_structure">Actualiser la mise à disposition des données aux structures</a></li>
			<li>
				<form method="get" action="index.php">
					Bilan intermédiaire
					<input type="hidden" name="t" value="taches"/>
					<input type="hidden" name="creer_tache" value="bilan-mois"/>
					<input type="text" name="annee" value="" placeholder="2016" style="width:50px;"/>
					<input type="text" name="mois" value="" placeholder="05" style="width:25px;" />
					<input type="submit" value="Créer"/>
				</form>
			</li>
			<li>
				<form method="get" action="index.php">
					Bilan annuel
					<input type="hidden" name="t" value="taches"/>
					<input type="hidden" name="creer_tache" value="bilan-annuel"/>
					<input type="text" name="annee" value="" placeholder="2016" style="width:50px;"/>
					<input type="submit" value="Créer"/>
				</form>
			</li>
		</ul>
	 {/if}
	</div>
</div>
{include file="footer.tpl"}
