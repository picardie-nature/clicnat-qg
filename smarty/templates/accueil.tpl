{include file="header.tpl" container_fluid=1}
{if $auth_ok}
<div class="row-fluid">
	<div class="span4">
		<h3>Citations : {$nb_citations}</h3>
		<fieldset><legend>Rechercher</legend>
			<input type="text" id="recherche_observateur" placeholder="Rechercher un observateur">
			<input type="text" id="recherche_espece" placeholder="Recherche une espèce">
			<form method="get" action="index.php">
				<input type="hidden" name="t" value="citation_edit"/>
				<input type="text" size="6" name="id" placeholder="Numéro citation"/>
				<button class="btn btn-info"><i class="icon-search icon-white"></i></button>
			</form>
			<form method="get" action="index.php">
				<input type="hidden" name="t" value="observation_edit"/>
				<input type="text" size="6" name="id" placeholder="Numéro observation"/>
				<button class="btn btn-info"><i class="icon-search icon-white"></i></button>
			</form>
		</fieldset>
	</div>
	<div class="span4">
		<fieldset><legend>Derniers comptes créés</legend>
		<ul class="nav nav-tabs nav-stacked">
			{foreach from=$derniers_comptes item=nouveau}
				<li><a href="?t=profil&id={$nouveau->id_utilisateur}">{$nouveau}</a></li>		
			{/foreach}
		</ul>
		</fieldset>
		<fieldset><legend>Dernières espèces ajoutées</legend>
		<ul class="nav nav-tabs nav-stacked">
			{foreach from=$dernieres_especes item=nouveau}
				<li><a href="?t=espece_detail&id={$nouveau->id_espece}">{$nouveau}</a></li>		
			{/foreach}
		</ul>

		</fieldset>
	</div>
	<div class="span4">
		<fieldset><legend>États saisie</legend>
			<h3>Nombre de citations crées par jour</h3>
			<div id="g_citations_crees"></div>
			<h3>Nombre de citations par jour</h3>
			<div id="g_citations_jour"></div>


		</fieldset>
	</div>
</div>
<script>
//{literal}
	J(init);

	function charge_graphique(url, element, xkey) {
			J.getJSON(url,null,
			function (data) {
				Morris.Line({
					element: element,
					data: data,
					xkey: xkey,
					ykeys: ['count'],
					labels : ['Citations crées'],
					xLabels: "day",
					dateFormat: function (d) {
						var d = new Date(d);
						return d.getDate()+"-"+(d.getMonth()+1)+"-"+(d.getYear()+1900);
					},
					xLabelFormat: function (d) {
						return d.getDate()+"-"+(d.getMonth()+1)+"-"+(d.getYear()+1900);
					},
					parseTime: true,
					gridEnabled: true,
					smooth: false,
					hideHover: 'auto'
				});
			}
		);
	}

	function init() {
		J('#recherche_espece').autocomplete({
			source: '?t=espece_autocomplete2&nohtml=1&affiche_expert=1&forcer_absent=1',
			select: function (event,ui) {
			    document.location.href = '?t=espece_detail&id='+ui.item.value;
			    event.target.value = '';
			    return false;
			}
		});
		J('#recherche_observateur').autocomplete({
			source:'?t=autocomplete_observateur',
			select: function (event,ui) {
			    document.location.href = '?t=profil&id='+ui.item.value;
			    event.target.value = '';
			    return false;
			}
		});
		charge_graphique('?t=plot_data&serie=citations_crees_par_jour','g_citations_crees','date_creation');
		charge_graphique('?t=plot_data&serie=citations_par_jour','g_citations_jour','date_observation');
	}
//{/literal}
</script>
{else}
<div class="login">
	<h1>Bienvenue,</h1>
	<form method="post" action="?t=accueil">
		<input type="hidden" name="act" value="login"/>
		Nom d'utilisateur : <input id='focusit'type="text" name="username"/><br/>
		Mot de passe : <input type="password" name="password"/><br/>
		<input type="submit" value="se connecter"/>
	</form>
	<script language="javascript">
		document.getElementById('focusit').focus();
	</script>
</div>
{/if}
{include file="footer.tpl"}
