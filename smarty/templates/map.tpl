<div id="map" style="width:100%; height:350px;"> </div>
{literal}
<script>
	Proj4js.defs['EPSG:27572']="+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs";
	map = new OpenLayers.Map('map',{
		projection: new OpenLayers.Projection("EPSG:27572"), 
		displayProjection: new OpenLayers.Projection("EPSG:4326"),
		units: "m",
		maxExtent: new OpenLayers.Bounds(530000, 2420000, 740000, 2600000),
		maxResolution: 5300000/100
		});
	var gphy = new OpenLayers.Layer.Google( "Google Relief", {type: G_PHYSICAL_MAP, 'sphericalMercator': true}); 
	var gmap = new OpenLayers.Layer.Google( "Google Plan", {numZoomLevels: 20,   'sphericalMercator': true});
	var ghyb = new OpenLayers.Layer.Google( "Google Hybride", {type: G_HYBRID_MAP, numZoomLevels: 20,  'sphericalMercator': true});
	var gsat = new OpenLayers.Layer.Google( "Google Aerien", {type: G_SATELLITE_MAP, numZoomLevels: 20, 'sphericalMercator': true});

	var editor = new OpenLayers.Layer.Vector( "Editeur", {});
	var top25 = new OpenLayers.Layer.WMS("IGN TOP25", "http://devel.picardie-nature.org/cgi-bin/tilecache.cgi", {layers: "top25"});
	var zones = new OpenLayers.Layer.WMS("Zones", "http://devel.picardie-nature.org/cgi-bin/tilecache.cgi", {layers: "zonage", transparent: true});
	var zones_t = new Array(
		new Array('10x10','Zonage Lambert 93 10x10'),
		new Array('littorale',"Photos littorale"),
		new Array('apb2008',"Arrêtés de protection de biotope"),
		new Array('bios2008',"Réserves de la biosphère"),
		new Array('celrl2007',"Terrains du Conservatoire du Littoral"),
		new Array('pn2008',"Parcs nationaux"),
		new Array('pnm2008',"Parc naturel marin"),
		new Array('pnr2008',"Parcs naturels régionaux"),
		new Array('ramsar2008',"Sites Ramsar"),
		new Array('rb2007',"Réserves biologiques"),
		new Array('rbce2003',"Réserves biogénétiques du Conseil de l'Europe"),
		new Array('rn2008',"Réserves naturelles"),
		new Array('rncfs2008',"Réserves nationales de chasse et faune sauvage"),
		new Array('rnv2000',"Réserves naturelles volontaires"),
		new Array('sic0907',"Site d'intérêt communautaire (SIC)"),
		new Array('zps0907',"Zones de protection spéciale (ZPS)"),
		new Array('zico',"Zones Importantes pour la Conservation des Oiseaux (ZICO)"),
		new Array('znieff1',"Zones Naturelles d’Intérêt Ecologique Faunistique et Floristique (ZNIEFF) 1"),
		new Array('znieff2',"Zones Naturelles d’Intérêt Ecologique Faunistique et Floristique (ZNIEFF) 2")
	);
	var zones_o = new Array();
	for (var i=0; i<zones_t.length; i++) {
		zones_o[i] = new OpenLayers.Layer.WMS(zones_t[i][1], "http://devel.picardie-nature.org/cgi-bin/tilecache.cgi", {layers: zones_t[i][0], transparent:true});
		zones_o[i].setVisibility(false);
	}

	map.addControl(new OpenLayers.Control.MousePosition());
	map.addLayers([top25,gphy,gmap,ghyb,gsat,zones,editor]);
	map.addLayers(zones_o);

	map.zoomToMaxExtent();
	liste_layer(map, 'layers');
</script>
{/literal}

<div class="mapbar">
	<div style="float:right;" id="map_status"></div>
	Fond de carte : <select id="fond"></select>
	<a href="javascript:;" onclick="javascript:zoom_min();">zoom min</a> -
	<a href="javascript:;" onclick="javascript:map.zoomToExtent(editor.getDataExtent());">zoom données</a>-
	<a href="javascript:;" onclick="javascript:clear_espace();">nettoyer</a> -
	<a href="javascript:;" onclick="javascript:alert(map.getScale());">Echelle</a>


	<div class="mapinfo">
		<b>La carte</b>
		<p class="directive">Projection</p>
		<p class="valeur" id="mapinfo_projection"></p>

		<p class="directive">Zone Max</p>
		<p class="valeur" id="mapinfo_maxextent"></p>

		<p class="directive">R&eacute;solution Max</p>
		<p class="valeur" id="mapinfo_resolution"></p>
	</div>
</div>

<script>
	{literal}
		mapinfo();
		select_fond_init_liste(map, 'fond');
	{/literal} 
</script>

