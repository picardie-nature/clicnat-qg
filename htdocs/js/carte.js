Proj4js.defs["EPSG:2154"] = "+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";

function carte_change_base_layer(evt)
{
    evt.object.projection = evt.object.baseLayer.projection;
}

function carte_inserer(imap) 
{
	var options = {
		projection: new OpenLayers.Projection('EPSG:2154'),
		displayProjection: new OpenLayers.Projection('EPSG:4326'),
		units: "m",
		//numZoomLevels: 18,
		//maxResolution: 156543.0339,
		//maxResolution: 75000,
		maxExtent: new OpenLayers.Bounds(570000,6840000,810000,7050000),
		resolutions: [9.155273,4.577637,2.288818]
	};
	imap = new OpenLayers.Map(imap.id, options);
	imap.addControl(new OpenLayers.Control.LayerSwitcher());

	//var l93 = new OpenLayers.Projection('EPSG:2154');

	/*var ghyb = new OpenLayers.Layer.Google("Google Hybride",
				{type: G_HYBRID_MAP, numZoomLevels: 20, sphericalMercator: true});
	var gphy = new OpenLayers.Layer.Google("Google Physique", 
				{type: G_PHYSICAL_MAP, sphericalMercator: true});
	var gmap = new OpenLayers.Layer.Google("Google Rues",  
				{numZoomLevels: 20, sphericalMercator: true});
	var gsat = new OpenLayers.Layer.Google("Google Satellite", 
				{type: G_SATELLITE_MAP, numZoomLevels: 20, sphericalMercator: true});*/

	var scan25 = new OpenLayers.Layer.WMS("SCAN 25", "?t=tc", {layers: "scan25", resolutions: [9.155273,4.577637,2.288818]});
	//scan25.projection = l93;
	imap.addLayers([scan25]);

	imap.events.register('changebaselayer', null, carte_change_base_layer);

	return imap;
}

function carte_enregistrer_point(nom,ref,x,y)
{
    var xhr = J.ajax({async:false, url:'?t=insertion_point&nom='+nom+'&x='+x+'&y='+y, dataType:'json'});
    log('carte_enregistre_point '+nom+' <= '+xhr.responseText);
    return xhr.responseText;
}

function carte_afficher_points(layer, recherche)
{
    var xhr = J.ajax({async:false, url:'?t=recherche_point&term='+recherche, dataType:'json'});

    var geojson = new OpenLayers.Format.GeoJSON({
	'internalProjection': layer.projection,
	'externalProjection': new OpenLayers.Projection("EPSG:4326")
    });

    // on doit pouvoir l'éviter en mettant la bonne entête a la réponse
    var t_json = J.parseJSON(xhr.responseText);
    var features = geojson.read(t_json);    
    
    if (layer.features)
	layer.removeFeatures(layer.features);

    if (features) {
	layer.addFeatures(features);
	layer.map.zoomToExtent(layer.getDataExtent());
    }
}
