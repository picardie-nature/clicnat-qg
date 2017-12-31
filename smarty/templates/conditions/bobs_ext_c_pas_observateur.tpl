Numéro d'observateur :
<input type="text" name="id_utilisateur" value="" id="rech_id_obsevateur"/>
<input type="hidden" name="classe" value="bobs_ext_c_pas_observateur"/>
<script>
    //{literal}
    J('#rech_id_observateur').autocomplete({source:'?t=autocomplete_observateur'});
    //{/literal}
</script>
