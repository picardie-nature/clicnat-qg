{include file="header.tpl" container_fluid=1}
<script type="text/javascript" src="http://maps.picardie-nature.org/OpenLayers-2.12/OpenLayers.debug.js"></script>
<script type="text/javascript" src="http://maps.picardie-nature.org/proj4js/lib/proj4js-compressed.js"></script>
<script type="text/javascript" src="http://maps.picardie-nature.org/carto.js"></script>
<script src="js/carte.js" language="javascript"></script>
<script>
//{literal}

function charger_tableau(id_import) {
	J('#bobs-s2-a').html('Chargement du tableau en cours');
	J('#bobs-s2-a').load('?t=import_obs_liste&id='+id_import);
}

function import_editer_obs(id_import, id_observation) {
	J('#observation').html('Chargement en cours...');
	J('#observation').load('?t=import_w_obs&id_import='+id_import+'&id_observation='+id_observation);
}

function import_valider_obs(id_import, id_observation) {
	J('#observation').html('Chargement en cours...');
	J('#observation').load('?t=import_w_obs&id_import='+id_import+'&id_observation='+id_observation+'&valide=1',
		function () {
			charger_tableau(id_import);
		}
	);
}

function import_obs_retirer_observateur(id_import, id_observation, id_utilisateur) {
	J('#observation').html('Chargement en cours...');
	J('#observation').load('?'+J.param({t: 'import_w_obs', id_import: id_import, id_observation: id_observation, enlever_id_utilisateur: id_utilisateur}));
}

function import_obs_ajouter_observateur(id_import, id_observation, id_utilisateur) {
	J('#observation').html('Chargement en cours...');
	J('#observation').load('?'+J.param({t: 'import_w_obs', id_import: id_import, id_observation: id_observation, ajouter_id_utilisateur: id_utilisateur}));
}

function recherche()
{
    carte_afficher_points(vecteurs, J('#bobs-location').val());
}

function pointer()
{
    ctrl_select.activate();
    ctrl_draw.deactivate();
}

function nouveau()
{
    ctrl_select.deactivate();
    ctrl_draw.activate();
}

var glob_cbl;
function nouveau_enregistrer(evt)
{
    glob_cbl = evt;
    var nom = prompt('Nom du point');
    if (!nom) {
	ctrl_draw.deactivate();
	return;
    }
    evt.feature.geometry.transform(map.projection, map.displayProjection);
    log('x='+evt.feature.geometry.x);
    log('y='+evt.feature.geometry.y);

    var id_espace = carte_enregistrer_point(nom, '',evt.feature.geometry.x, evt.feature.geometry.y);
    var id_imp = J('#w_id_import').val();
    var id_obs = J('#w_id_observation').val();
    J('#observation').html('Chargement en cours...');
    J('#observation').load('?t=import_w_obs&id_import='+id_imp+'&id_observation='+id_obs+'&id_espace='+id_espace,
	function () { charger_tableau(id_imp); });    
}

function espace_selection(evt)
{
    var id_imp = J('#w_id_import').val();
    var id_obs = J('#w_id_observation').val();
    var id_espace = evt.feature.data.id_espace;

    J('#observation').html('Chargement en cours...');
    J('#observation').load('?t=import_w_obs&id_import='+id_imp+'&id_observation='+id_obs+'&id_espace='+id_espace,
	function () { charger_tableau(id_imp); });
}

function creation_citation(formulaire, num_ligne)
{
    var args = J('#'+formulaire).serialize();
    log(args);
    J('#cit_r_'+num_ligne).load('?t=import_w_obs_create_citation&'+args);
    J('#'+formulaire).hide();
}

function modifier_nom_espece(nligne, nobs)
{
    J('#me_nouveau_nom').val(J('#esp-'+nligne).html());
    J('#me_num_ligne').val(nligne);
    J('#me_id_observation').val(nobs);
    J('#bobs-dlg-esp').dialog({buttons:{
	    Fermer: function () { J('#bobs-dlg-esp').dialog('close'); },
	    Enregistrer: function () {		
		log(J('#me').serialize());
		J('#observation').html('Chargement en cours...');
		J('#observation').load('?'+J('#me').serialize());
		J('#bobs-dlg-esp').dialog('close');
	    }
    }});
}
//{/literal}
</script>
<div style="display:none;">
    <div id="bobs-dlg-esp" title="Modifier le nom de l'espèce">
	Nom<br/>
	<form id="me">
	    <input type="hidden" name="t" value="import_w_obs"/>
	    <input type="hidden" id="me_id_observation" name="id_observation"/>
	    <input type="hidden" id="me_id_import" value="{$import->id_import}" name="id_import"/>
	    <input type="hidden" id="me_num_ligne" name="num_ligne"/>
	    <input type="text" id="me_nouveau_nom" name="set_nom_esp"/>
	</form>
    </div>
</div>
<div class="row-fluid">
	<div class="span12">
		<div class="fix_bootstrap_map" id="bobs-imp-carte" style="width: 100%; height: 400px;"></div>
		<button class="btn btn-mini btn-info" id="bascule">Basculer la carte</button>
		<div class="row-fluid">
		    	<div id="bobs-s2-a" class="span6"></div>
		    	<div id="bobs-s2-b" class="span6">
				<div id="observation">
					<a href="?t=import_obs&act=creer_observations&id={$import->id_import}">Relancer la création des observations (supprime ce qui a déjà été fait)</a>
					<p class="directive">Nombre d'observations</p>
					<p class="valeur">{$import->get_imp_observation_n()}</p>
				</div>
		    	</div>
		</div>
	</div>
</div>
<script>
    //{literal}
	log('dessiner la carte');
	//var map = carte_inserer(document.getElementById('bobs-imp-carte'));
	var carto = new Carto('bobs-imp-carte');
	var map = carto.map;
	var vecteurs = new OpenLayers.Layer.Vector('Resultats');
	map.addLayer(vecteurs);

	var ctrl_select = new OpenLayers.Control.SelectFeature([vecteurs], {});
	ctrl_select.events.register('featurehighlighted', null, espace_selection);
	map.addControl(ctrl_select);

	var ctrl_draw = new OpenLayers.Control.DrawFeature(vecteurs, OpenLayers.Handler.Point);
	ctrl_draw.events.register('featureadded', null, nouveau_enregistrer);
	map.addControl(ctrl_draw);
	J('#bascule').click(function () {J("#bobs-imp-carte").toggle()});
    //{/literal}
	charger_tableau({$import->id_import});
	
</script>
{include file="footer.tpl"}
