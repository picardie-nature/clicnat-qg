<input type="text" name="id_espace" id="srch_commune"/>
<br/>
<input type="hidden" name="classe" value="bobs_ext_c_commune"/>
<small>indiquez ici le nom d'une commune</small>
<div id="srch_commune_choix" class="autocomplete"></div>
<script>
{literal}
J('#srch_commune').autocomplete({source:'?t=autocomplete_commune'});
{/literal}
</script>
