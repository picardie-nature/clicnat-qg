Numéro d'observateur :
<input type="text" name="id_utilisateur" value="" id="rech_id_observ"/>
<input type="hidden" name="classe" value="bobs_ext_c_auteur"/>
<script>
    //{literal}
    J('#rech_id_observ').autocomplete({source:'?t=autocomplete_observateur'});
    //{/literal}
</script>
