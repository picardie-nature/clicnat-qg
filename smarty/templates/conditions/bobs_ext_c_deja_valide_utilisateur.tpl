Numéro d'observateur :
<input type="text" name="id_utilisateur" value="" id="rech_id_validateur"/>
<input type="hidden" name="classe" value="bobs_ext_c_deja_valide_utilisateur"/>
<script>
    //{literal}
    J('#rech_id_validateur').autocomplete({source:'?t=autocomplete_observateur'});
    //{/literal}
</script>
