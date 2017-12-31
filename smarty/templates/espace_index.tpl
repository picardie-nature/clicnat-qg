{include file="header.tpl"}
{if $auth_ok}
<h1>Espaces</h1>
{include file=map.tpl}
<div class="mapbar">
	<a href="javascript:;" onclick="javascript:espaces_dans_la_carte();">esp. dans la carte</a>
</div>
{/if}

{literal}
<script>
function add_espace(es, geomtype)
{	
	parser = new OpenLayers.Format.WKT({internalProjection: map.projection, externalProjection: new OpenLayers.Projection("EPSG:4326")});

	feature = parser.read(es.point);
	feature.bobs_id_espace = es.id_espace;
	feature.bobs_type = geomtype;
	feature.bobs_nom = es.nom;

	//feature = new OpenLayers.Feature.Vector(geom.geometry);
	editor.addFeatures([feature]);
}

function add_espace_by_id(id, geomtype)
{
	var es = get('?t=espace_'+geomtype+'_id_json&id='+id);
	add_espace(es, geomtype);
	//parser = new OpenLayers.Format.WKT({internalProjection: new OpenLayers.Projection("EPSG:3785"), externalProjection: new OpenLayers.Projection("EPSG:4326")});
}

function tableau_espaces()
{
	var divt = document.getElementById('liste_espaces_dans_carte');
	var tableau = document.createElement('table');
	var h = document.createElement('h1');
	var row;
	var cell;
	var a;
	while (divt.lastChild != null)
		divt.removeChild(divt.lastChild);

	h.appendChild(document.createTextNode('Liste des espaces'));
	divt.appendChild(h);

	for (var i=0; i<editor.features.length; i++) {
		row = tableau.insertRow(i);
		cell = row.insertCell(0);
		a = document.createElement('href');
		a.feature = editor.features[i];
		a.onclick = function (e) { espace_details(e.target.feature); };
		a.innerHTML = editor.features[i].bobs_id_espace;
		cell.appendChild(a);
		cell = row.insertCell(1);
		cell.appendChild(document.createTextNode(editor.features[i].bobs_nom));
	}
	divt.appendChild(tableau);
}

function espaces_dans_la_carte()
{
	espace_message("chargement en cours...");
	geomtype = 'point';
	zone = map.getExtent().toGeometry().transform(map.projection, map.displayProjection);
	ess = get('?t=espace_'+geomtype+'_dans_zone&zone='+zone);
	if (ess.length > 300) {
		espace_message("trop d'éléments a afficher");
		return;
	}
	for (var i = 0; i < ess.length; i++) {
		if (ess[i] != null)
			add_espace(ess[i], geomtype);
	}
	tableau_espaces();
}

function espace_message(msg)
{
	document.getElementById('liste_espaces_dans_carte').innerHTML = msg;
}

function espace_details(feature)
{
	document.getElementById('detail_espace').innerHTML = wget('?t=espace_detail&id='+feature.bobs_id_espace);	
}

function clear_espace()
{
	editor.destroyFeatures();
}
</script>
{/literal}
<div id="liste_espaces_dans_carte" class="liste_carte">
</div>

<div id="detail_espace">
</div>

{include file="footer.tpl"}
