<!DOCTYPE html>
<html lang="fr">
<head>
	<meta charset="utf-8">
	<meta name="Classification" content="">
	<meta name="Description" content="">
	<meta name="KeyWords" content="">
	<title>Clicnat - QG</title>
	<link rel="stylesheet" type="text/css" href="http://maps.picardie-nature.org/OpenLayers-2.12/theme/default/style.css" />
	<link href="assets/morris/morris.css" rel="stylesheet" type="text/css" />
	<link href="assets/jqueryui/themes/smoothness/jquery-ui.css" media="screen" rel="stylesheet" type="text/css" />
	<link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen"/>
	<link href="assets/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" media="screen"/>
	<link rel="stylesheet" type="text/css" href="css/style_bs.css"/>
</head>
<body>

<script src="assets/jquery/jquery.js"></script>
<script src="js/bobs.js"></script>
<script src="assets/jqueryui/jquery-ui.js"></script>
<script src="js/jquery.ui.datepicker-fr.js" language="javascript"></script>
<script src="js/jquery.lazyload.js"></script>
<script src="assets/bootstrap/js/bootstrap.min.js"></script>
<script src="assets/raphael/raphael-min.js"></script>
<script src="assets/morris/morris.js"></script>

<div class="container-fluid">
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="brand" href="?t=accueil">Clicnat QG</a>
			{if $auth_ok}
			<div class="nav-collapse collapse">
				<ul class="nav">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Observations<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="?t=validation">Validation</a></li>
							<li><a href="?t=validation_photo">Validation (photos fiches)</a></li>
						</ul>
					</li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Espèces<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="?t=referentiel_regional">Référentiel régional</a></li>
							<li><a href="?t=espece_nouveau">Ajouter une espèce</a></li>
							<li><a href="?t=espece_insert_inpn">Ajouter une espèce (Code INPN)</a></li>
							<li class="divider"></li>
							{foreach from=$menu_classes item=classe key=kclasse}
							<li><a href="?t=especes_index&classe={$kclasse}">{$classe}</a></li>
							{/foreach}
							<li class="divider"></li>
							<li><a href="?t=arbre">Arbre taxo</a></li>

						</ul>
					</li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Observateurs<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="?t=preinscription">Pré-inscription</a></li>
							<li><a href="?t=juniors">Nouveaux inscrits</a></li>
							<li class="divider"></li>
							<li><a href="?t=observateurs_liste">Liste</a></li>
							<li><a href="?t=observateur_nouveau">Ajouter</a></li>
							<li><a href="?t=observateur_recherche&restreint=1">Diffusion restreinte</a></li>
							<li><a href="?t=observateur_recherche&reglement_ok=1">Réglement signé</a></li>
							<li class="divider"></li>
							<li><a href="?t=imports_liste">Imports en cours</a></li>
						</ul>
					</li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Sélections<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="?t=extraction">Nouvelle extraction</a></li>
							<li><a href="?t=selections">Liste des sélections</a></li>
						</ul>
					</li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Administration<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="?t=tags">Étiquettes</a></li>
							<li><a href="?t=commentaires">Commentaires</a></li>
							<li><a href="?t=enquetes">Enquêtes</a></li>
							<li><a href="?t=chiros">Chiros</a></li>
							<li><a href="?t=taches">Taches</a></li>
							<li><a href="?t=textes">Textes</a></li>
							<li><a href="?t=travaux">Travaux</a></li>
							<li><a href="?t=structures">Structures</a></li>
							<li><a href="?t=reseaux">Réseaux</a></li>
							<li><a href="?t=protocoles">Protocoles</a></li>
						</ul>
					</li>
					<li>
						<a href="?t=accueil&fermer=1">Fermer</a>
					</li>
				</ul>
			</div>

			{/if}
		</div>
	</div>
</div>
<div class=".visible-desktop">
	<div style="height:60px; width:100%;"></div>
</div>
<script>
    {literal}
	var J = jQuery.noConflict();
	var glob_ev;
	var glob_ui;
	function log(msg) {
		try {
			if (console.firebug)
				console.info(msg);
		} catch (e) {
			return false;
		}
	}

	log('firebug ok');
	function qg_rech_nom_autocomplete(event, ui) {
	    J('#qg-rech-nom-id').val(ui.item.value);
	    ui.item.value = ui.item.label;
	}
/*
	J('#qg-rech-nom').autocomplete({source:'?t=autocomplete_observateur'});
	J('#qg-rech-nom').bind('autocompleteselect', qg_rech_nom_autocomplete);
	J('#qg-rech-esp').autocomplete({source:'?t=autocomplete_espece'});*/
/*	J('#recherche_espece').autocomplete({source: '?t=espece_autocomplete2&nohtml=1',
		select: function (event,ui) {
		    document.location.href = '?t=espece_detail&id='+ui.item.value;
		    event.target.value = '';
		    return false;
		}
	});*/
    {/literal}
</script>
<!--
{if $auth_ok}
<div class="menu2">
	<h1>Observations</h1>
	<div class="smenu">
		<a href="?t=commune_index">Communes</a>
		<a href="?t=validation">Validation des obs.</a>
		<a href="?t=validation_photo">Validation photos fiches</a>
		<form method="get" action="index.php">
			N. Citation<br/>
			<input type="hidden" name="t" value="citation_edit"/>
			<input type="text" size="6" name="id"/>
			<input type="submit" value="go"/>
		</form>
		<form method="get" action="index.php">
			N. Observation<br/>
			<input type="hidden" name="t" value="observation_edit"/>
			<input type="text" size="6" name="id"/>
			<input type="submit" value="go"/>
		</form>
	</div>
	<h1>Espèces</h1>
	<div class="smenu">
		<a href="?t=especes_index&classe=A">Arachnides</a>
		<a href="?t=especes_index&classe=B">Batraciens</a>
		<a href="?t=especes_index&classe=R">Reptiles</a>
		<a href="?t=especes_index&classe=O">Oiseaux</a>
		<a href="?t=especes_index&classe=M">Mammifères</a>
		<a href="?t=especes_index&classe=I">Insectes</a>
		<a href="?t=especes_index&classe=P">Poissons</a>
		<a href="?t=especes_index&classe=L">Mollusques</a>
		<a href="?t=especes_index&classe=N">Annélides</a>
		<a href="?t=especes_index&classe=C">Crustacés</a>
		<a href="?t=referentiel_regional">Référentiel régional</a>
		<a href="?t=espece_nouveau">Ajouter une espèce</a>
	</div>
	<h1>Observateurs</h1>
	<div class="smenu">
		<a href="?t=preinscription">Préinscriptions</a>
		<a href="?t=juniors">Les nouveaux</a>
		<a href="?t=observateurs_liste">Liste</a>
		<a href="?t=observateur_nouveau">Ajouter</a>
		<a href="?t=observateur_recherche">Recherche</a>
		<a href="?t=observateur_recherche&restreint=1">En diff. restreinte</a>
		<a href="?t=observateur_recherche&reglement_ok=1">Réglement signé</a>
		<a href="?t=imports_liste">Liste des imports en cours</a>
	</div>
	<h1>Sélections</h1>
	<div class="smenu">
	    <a href="?t=extraction">Extraction</a>
	    <a href="?t=selections">Liste</a>
	</div>
	<h1>Administration</h1>
	<div class="smenu">
		<a href="?t=tags">Tags - Étiquettes</a>
		<a href="?t=commentaires">Commentaires</a>
		<a href="?t=enquetes">Enquêtes</a>
		<a href="?t=chiros">Chiros</a>
		<a href="?t=textes">Textes</a>
	</div>
</div>
{else}
<div class="menu"></div>
<div class="menu2">
	Vous n'êtes pas connecté.
	<a href="index.php?t=accueil">Cliquez ici pour vous connecter</a>
</div>
{/if}
-->
{if count($alertes)>0}
{foreach from=$alertes item=alerte}
	<div class="alert alert-{$alerte.classe}">
		{$alerte.message}
	</div>
{/foreach}
{/if}

{if isset($messageinfo)}
<div class="topinfo">
	{$messageinfo}
</div>
{/if}
{if $container_fluid}
	<div class="container-fluid">
{else}
	<div class="container">
{/if}
