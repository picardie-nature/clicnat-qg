
// Fonctions commune pour la carte


function mapinfo()
{
	document.getElementById('mapinfo_projection').innerHTML = map.projection;
	document.getElementById('mapinfo_maxextent').innerHTML = map.getMaxExtent().toGeometry().transform(map.projection, map.displayProjection); 
	document.getElementById('mapinfo_resolution').innerHTML = map.getMaxResolution();
}

function fond_change(n_layer)
{
	var proj_src = map.projection;
	var ext = map.getExtent();
	map.projection = map.layers[n_layer].projection;
	if ((map.layers[n_layer] == top25) || (map.layers[n_layer] == zones)) {
		map.projection = new OpenLayers.Projection("EPSG:27572");
		map.maxExtent.left = 530000;
		map.maxExtent.right = 740000;
		map.maxExtent.top = 2600000;
		map.maxExtent.bottom = 2420000;
		map.maxResolution = 5300000/100;
	} else {
		map.projection = new OpenLayers.Projection("EPSG:900913");
		map.maxExtent.left = -20037508;
		map.maxExtent.right = 20037508;
		map.maxExtent.top = 20037508.34;
		map.maxExtent.bottom = -20037508;
		map.maxResolution = 156543.0339;
	}
	map.maxExtent.centerLonLat = null;

	if (map.projection.getCode() != proj_src.getCode()) {
		ext.transform(proj_src, map.projection);
		for (var i = 0; i < editor.features.length; i++) {
			editor.features[i].geometry.transform(proj_src, map.projection);
		}
		map.zoomToExtent(ext);
		
	}
	map.setBaseLayer(map.layers[n_layer]);
	mapinfo();
}

function zoom_min()
{
	map.zoomToExtent(map.maxExtent);
}

function select_fond_change(evt)
{
	fond_change(evt.currentTarget.value);
}

function select_fond_init_liste(map, select_id)
{
	select = document.getElementById(select_id);
	for (i=0;i<map.layers.length;i++) {
		if (!map.layers[i].isBaseLayer) continue;
		var opt = document.createElement('option');
		opt.value = i;
		opt.text = map.layers[i].name;
		select.add(opt,null);
	}
	select.onchange = select_fond_change;
}
function liste_visibility_change(evt)
{
	var new_st = evt.currentTarget.checked;
	var i = evt.currentTarget.id_layer;
	evt.currentTarget.checked = new_st;
	map.layers[i].setVisibility(new_st);
}

function liste_layer(map, divid)
{
	div = document.getElementById(divid);
	for (i=0;i<map.layers.length;i++) {
		if (map.layers[i].isBaseLayer) continue;
		var txt = document.createTextNode(map.layers[i].name);
		var input = document.createElement('input');
		var p = document.createElement('div');
		p.style.fontSize = '10px';
		input.type = 'checkbox';
		input.id = 'layer_'+i;
		input.id_layer = i;
		input.onclick = liste_visibility_change;
		if (map.layers[i].getVisibility())
			input.checked = 'true';
		p.appendChild(input);
		p.appendChild(txt);
		div.appendChild(p);
	}
}
// Ajaxeries
function wget(url)
{
	var req = new XMLHttpRequest();
	req.open('GET', url, false);
	req.send(null);
	if (req.status == 200) {
		return req.responseText;
	}
}

function get(url)
{
	var req = new XMLHttpRequest();
	req.open('GET', url, false);
	req.send(null);  
	if (req.status == 200) {
		eval('t='+req.responseText); 
	}
	return t;
}

// Tableau alpha
function tab_alf_alphabet(div_id)
{	
	var a;
	var ret_str = '';
	var dest = document.getElementById(div_id);
	for (var i = 97; i < 97 + 26; i++) {
		lettre = String.fromCharCode(i);
		a = document.createElement('a');
		a.innerHTML = lettre.toUpperCase();
		a.href="javascript:;";
		a.onclick = tab_alf_filtre;
		dest.appendChild(a);
		if (lettre != 'z')
			dest.appendChild(document.createTextNode('-'));
	}
}

function tab_alf_filtre(evt)
{
	var sty;
	var lettre;
	var i,j;
	var lignes;
	for (i = 97; i < 97 + 26; i++) {
		sty = 'none';
		lettre = String.fromCharCode(i);
		if (evt.target.innerHTML.toLowerCase() == lettre) {
			sty = 'table-row';
		}
		lignes = document.getElementsByName('lettre_'+lettre);
		for (j=0; j<lignes.length; j++) 
			lignes[j].style.display = sty;
	}
}

