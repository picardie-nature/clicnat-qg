<?php
/**
  * BaseObs
  *
  **/
namespace Picnat\Clicnat;

use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_zps;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_zsc;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_ordre;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_epci;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_liste_especes;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_tag_protocole;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_classe;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_reseau;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_tag_structure;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_departement;
use Picnat\Clicnat\ExtractionsConditions\bobs_ext_c_structure;

$start_time = microtime(true);
$disallow_dump = false;

if (file_exists('config.php')) require_once('config.php');
else require_once('/etc/baseobs/config.php');

define('TITRE_PAGE', "Base d'observations - QG");
define('TITRE_H1', 'Picardie-Nature');
define('TITRE_H2', TITRE_PAGE);
define('SESS', 'QG');
define('GOOGLE_KEY', '');
define('FORMAT_DATE_COMPLET', '%A %d %B %Y');
define('LOCALE', 'fr_FR.UTF-8');
define('UTLSEL', 'id_utilisateur_sel');
define('UTLSEL_NOM', 'id_utilisateur_nom');



if (!defined('RACINE_ARBRE_TAXO')) define('RACINE_ARBRE_TAXO', 5269);
require_once('../vendor/autoload.php');

if (!class_exists("Smarty")) throw new \Exception("Error Processing Request ".SMARTY_DIR, 1);

class Qg extends clicnat_smarty  {
	function __construct($db) {
		parent::__construct($db, SMARTY_TEMPLATE_QG, SMARTY_COMPILE_QG, SMARTY_CONFIG_QG);
	}

	protected function template($selection_tpl = false) {
		$template = (empty($_POST['t'])?(empty($_GET['t'])?'accueil':$_GET['t']):$_POST['t']);
		if ($selection_tpl) {
			switch ($template) {
				case 'espace_point_id_json': $template = 'json_generique'; break;
				case 'espace_point_dans_zone': $template = 'json_generique'; break;
				case 'observateur_selectionner': $template = 'profil'; break;
				case 'especes_import_ref_pn_oiseaux': $template = 'especes_import_ref_pn'; break;
			}
		}
		return $template;
	}

	protected function before_reseaux() {
		$action = null;
		if (isset($_GET['action'])) $action = $_GET['action'];
		if (isset($_POST['action'])) $action = $_POST['action'];

		$reseau = null;

		if (isset($_GET['reseau']))
			$reseau = clicnat2_reseau::getInstance($this->db, $_GET['reseau']);

		switch ($action) {
			case 'nouveau':
				clicnat2_reseau::insert($this->db, "reseau", ['id' => $_POST['id'], 'nom' => $_POST['nom']]);
				break;
			case 'ajouter_coordinateur':
				if (empty($reseau))
					throw new \Exception("pas de réseau sélectionné");
				$u = get_utilisateur($this->db, (int)$_POST['id_utilisateur']);
				$reseau->ajouter_coordinateur($u);
				$this->ajoute_alerte('info', "Coordinateur $u ajouté au réseau $reseau");
				$this->redirect("?t=reseaux&reseau={$reseau->get_id()}");
				break;
			case 'retirer_coordinateur':
				if (empty($reseau))
					throw new \Exception("pas de réseau sélectionné");
				$u = get_utilisateur($this->db, (int)$_GET['id_utilisateur']);
				$reseau->retirer_coordinateur($u);
				$this->ajoute_alerte('info', "Coordinateur $u retiré du réseau $reseau");
				$this->redirect("?t=reseaux&reseau={$reseau->get_id()}");
				break;
			case 'retirer_validateur':
				if (empty($reseau))
					throw new \Exception("pas de réseau sélectionné");
				$u = get_utilisateur($this->db, (int)$_GET['id_utilisateur']);
				$reseau->retirer_validateur($u,(int)$_GET['id_espece']);
				$espece = get_espece($this->db, (int)$_GET['id_espece']);
				$this->ajoute_alerte('info', "Validation de la branche $espece retirée à $u");
				$this->redirect("?t=reseaux&reseau={$reseau->get_id()}");
				break;
			case 'ajouter_validateur':
				if (empty($reseau))
					throw new \Exception("pas de réseau sélectionné");
				$u = get_utilisateur($this->db, (int)$_POST['id_utilisateur']);
				$e = get_espece($this->db, (int)$_POST['id_espece']);
				$reseau->ajouter_validateur($u, $e);
				$this->ajoute_alerte('info', "Validateur $u ajouté au réseau $reseau pour les taxons en dessous de $e");
				$this->redirect("?t=reseaux&reseau={$reseau->get_id()}");
				break;
			case 'ajouter_branche':
				if (empty($reseau))
					throw new \Exception("pas de réseau sélectionné");
				$e = get_espece($this->db, (int)$_POST['id_espece']);
				$reseau->ajouter_branche($e);
				$this->ajoute_alerte('info', "Branche $e ajouté au réseau $reseau");
				$this->redirect("?t=reseaux&reseau={$reseau->get_id()}");
				break;
			case 'retirer_branche':
				if (empty($reseau))
					throw new \Exception("pas de réseau sélectionné");
				$e = get_espece($this->db, (int)$_GET['id_espece']);
				$reseau->retirer_branche($e);
				$this->ajoute_alerte('info', "Branche $e retirée du réseau $reseau");
				$this->redirect("?t=reseaux&reseau={$reseau->get_id()}");
				break;
			case 'ajouter_membre':
				if (empty($reseau))
					throw new \Exception("pas de réseau sélectionné");
				$u = get_utilisateur($this->db, (int)$_POST['id_utilisateur']);
				$reseau->ajouter_membre($u);
				$this->ajoute_alerte("info","$u ajouté au réseau $reseau");
				$this->redirect("?t=reseaux&reseau={$reseau->get_id()}");
				break;
			case 'retirer_membre':
				if (empty($reseau))
					throw new \Exception("pas de réseau sélectionné");
				$u = get_utilisateur($this->db, (int)$_GET['id_utilisateur']);
				$reseau->retirer_membre($u);
				$this->ajoute_alerte("info","$u retiré du réseau $reseau");
				$this->redirect("?t=reseaux&reseau={$reseau->get_id()}");
				break;
		}
		$this->assign('reseau', $reseau);
		$this->assign('reseaux', clicnat2_reseau::liste_reseaux($this->db));
	}

	protected function before_protocoles() {
		if (isset($_GET['action'])) {
			switch ($_GET['action']) {
				case 'ajouter':
					clicnat_protocoles::insert($this->db, [
						'id_protocole' => $_POST['id_protocole'],
						'lib' => $_POST['lib']
					]);
					$this->redirect("?t=protocoles");
					break;
				case 'maj':
					$protocole = new clicnat_protocoles($this->db, $_POST['id']);
					$protocole->update_field('lib', $_POST['lib']);
					$protocole->update_field('description', $_POST['description']);
					$protocole->update_field('ouvert', $_POST['ouvert']);
					$this->redirect("?t=protocoles&id={$protocole->id_protocole}");
					break;
			}
		}
		$this->assign('protocoles', clicnat_protocoles::liste($this->db));
		$this->assign('protocole', false);
		if (isset($_GET['id'])) {
			$this->assign('protocole', new clicnat_protocoles($this->db, $_GET['id']));
		}
	}

	protected function before_arbre() {
		$id_espece = isset($_GET['id_espece'])?(int)$_GET['id_espece']:RACINE_ARBRE_TAXO;
		$this->assign('espece', get_espece($this->db, $id_espece));
	}

	protected function before_taches() {
		if (isset($_GET['creer_tache'])) {
			$now = strftime("%Y-%m-%d %H:%M:%S",mktime());
			switch ($_GET['creer_tache']) {
				case 'bornes_especes':
					clicnat_tache::ajouter($this->db, $now, $_SESSION[SESS]['id_utilisateur'], 'Mise à jour bornes arbre taxo', 'bobs_espece_tr_maj_bornes', []);
					break;
				case 'mad_structure':
					clicnat_tache::ajouter($this->db, $now, $_SESSION[SESS]['id_utilisateur'], "MAD Structures","clicnat_structure_tr_mad", []);
					break;
				case 'bilan-mois':
					clicnat_tache::ajouter($this->db, $now, $_SESSION[SESS]['id_utilisateur'],
						sprintf("Bilan mensuel %d-%d",$_GET['mois'],$_GET['annee']),
						'clicnat_tr_bilan_mois',
						[
							'mois'=>(int)$_GET['mois'],
							'annee'=>(int)$_GET['annee']
						]
					);
					break;
				case 'bilan-annuel':
					clicnat_tache::ajouter($this->db, $now, $_SESSION[SESS]['id_utilisateur'],
						sprintf("Bilan annuel %d", $_GET['annee']),
						'clicnat_tr_bilan_annuel',
						['annee'=>(int)$_GET['annee']]
					);
					break;
				default:
					throw new \Exception('id tache inconnu');
			}
			self::redirect('?t=taches');
		}
		if (isset($_GET['id'])) {
			$tache = new clicnat_tache($this->db, (int)$_GET['id']);
			if (isset($_GET['modif'])) {
				switch ($_GET['modif']) {
					case 'exec_maintenant':
						$tache->exec_now();
						break;
					case 'annuler':
						$tache->annuler();
						break;
				}
				$this->redirect("?t=taches&id={$tache->id_tache}");
			} else {
				$this->assign_by_ref('tache_sel', $tache);
			}
		}
		$this->assign_by_ref('planif', clicnat_tache::planif($this->db));
		$this->assign_by_ref('en_attente', clicnat_tache::en_attente($this->db));
		$this->assign_by_ref('en_cours', clicnat_tache::en_cours($this->db));
		$this->assign_by_ref('terminees', clicnat_tache::dernieres_terminees($this->db));

	}

	protected function before_travaux() {
		if (isset($_POST['nouveau_titre']) && !empty($_POST['nouveau_titre'])) {
			switch ($_POST['type']) {
				case 'images':
					clicnat_travaux_images::nouveau($this->db, $_POST['nouveau_titre']);
					break;
				case 'lien':
					clicnat_travaux_lien::nouveau($this->db, $_POST['nouveau_titre']);
					break;
				case 'wfs':
					clicnat_travaux_wfs::nouveau($this->db, $_POST['nouveau_titre']);
					break;
				case 'wms':
					clicnat_travaux_wms::nouveau($this->db, $_POST['nouveau_titre']);
					break;
				default:
					throw new \Exception("type inconnu");
			}
			$this->redirect('?t=travaux');
		}
		if (isset($_GET['id'])) {
			$travail = clicnat_travaux::instance($this->db, $_GET['id']);
			$this->assign('travail',  $travail);
			if (isset($_GET['modifier'])) {
				$vars = array('titre','description');
				foreach ($vars as $v) {
					if (isset($_POST[$v])) {
						$travail->update_field($v, $_POST[$v]);
					}
				}
			} elseif (isset($_GET['ajouter_image'])) {
				$travail->ajoute_image($_POST['url']);
				$this->redirect('?t=travaux&id='.$travail->id_travail);
			} elseif (isset($_GET['def_lien'])) {
				$travail->lien($_POST['url']);
				$this->redirect('?t=travaux&id='.$travail->id_travail);
			} elseif (isset($_GET['def_wfs'])) {
				$travail->liste_espace($_POST['id_liste_espace']);
				$travail->sld($_POST['sld']);
				$this->redirect('?t=travaux&id='.$travail->id_travail);
			} elseif (isset($_GET['def_wms'])) {
				$travail->url_wms($_POST['url_wms']);
				$travail->layers($_POST['layers']);
				$travail->attribution($_POST['attribution']);
			}

			if ($travail->type == 'wfs') {
				$this->assign_by_ref("listes_espaces", clicnat_listes_espaces::liste_public($this->db));
			}
		}
		$this->assign('travaux', clicnat_travaux::liste($this->db));
	}

	protected function before_textes() {
		if (isset($_POST['nouveau_nom'])) {
			$id = clicnat_textes::nouveau($this->db, $_POST['nouveau_nom']);
			$this->redirect("?t=textes&id=$id");
		}
		if (isset($_GET['id'])) {
			self::cli($_GET['id'], bobs_element::except_si_inf_1);
			$texte = new clicnat_textes($this->db, $_GET['id']);
			if (isset($_POST['texte'])) {
				$texte->set_texte($_POST['texte']);
			}
			$this->assign('texte', $texte);
		}
		$this->assign('textes', clicnat_textes::liste($this->db));
	}

	protected function before_enquetes() {
		if (isset($_POST['nom_enquete'])) {
			$enq = clicnat_enquete::ajouter($this->db, $_POST['nom_enquete']);
			$this->ajoute_alerte('info', "Enquête {$enq} ajoutée");
			$this->redirect('?t=enquetes');
		}
		if (array_key_exists('enq', $_GET)) {
			$enq = new clicnat_enquete($this->db, (int)$_GET['enq']);
			$this->assign_by_ref('enq', $enq);
			switch ($_GET['a']) {
				case 'ajouter_version':
					$enq->ajouter_une_version();
					$this->ajoute_alerte('info', "Enquête {$enq} ajoutée");
					$this->redirect("?t=enquetes&enq={$enq->id_enquete}");
					break;
				case 'ajouter_taxon':
					$enq->ajouter_taxon($_POST['id_espece']);
					$this->ajoute_alerte('info', "Espèce ajoutée");
					$this->redirect("?t=enquetes&enq={$enq->id_enquete}");
					break;
				case 'retirer_taxon':
					$enq->retirer_taxon($_GET['id_espece']);
					$this->ajoute_alerte('info', "Espèce retirée");
					$this->redirect("?t=enquetes&enq={$enq->id_enquete}");
					break;
			}
			if (array_key_exists('ver', $_GET)) {
				$ver = $enq->version((int)$_GET['ver']);
				switch ($_GET['a']) {
					case 'maj_definition':
						$ver->sauve_definition($_POST['definition']);
						break;
					case 'extraction':
						$extraction = new bobs_extractions($this->db);
						$extraction->ajouter_condition(new bobs_ext_c_enquete_version($_GET['enq'], $_GET['ver']));
						$_SESSION[SESS]['extraction'] = $extraction;
						$this->redirect('?t=extraction');
						break;
					case 'csv':
						header("Content-Type: text/csv");
						header("Content-disposition: filename=enquete_{$_GET['enq']}_{$_GET['ver']}.csv");
						$ver->csv(fopen('php://output','w'));
						exit();
						break;
				}
				$this->assign_by_ref('ver', $ver);
			}
		}
		$this->assign_by_ref('enquetes', clicnat_enquete::enquetes($this->db));
	}

	protected function before_juniors() {
		$this->assign('observateurs', bobs_utilisateur::juniors($this->db));
	}

	protected function before_obs_par_mois() {
		$u = get_utilisateur($this->db, $_GET['utilisateur']);
		if (!isset($_GET['y'])) $y = strftime("%Y");
		else $y = (int)$_GET['y'];
		$this->header_json();
		echo json_encode($u->get_n_obs_par_mois($y));
		exit();
	}

	protected function before_validation_sur_photo() {
		$tag_attv = bobs_tags::by_ref($this->db, TAG_ATTENTE_VALIDATION);
		$extraction = new bobs_extractions($this->db);
		$extraction->ajouter_condition(new bobs_ext_c_a_document());
		$extraction->ajouter_condition(new bobs_ext_c_tag($tag_attv->id_tag));
		$tmp_citations = $extraction->dans_un_tableau();
		$citations = array();
		foreach ($tmp_citations as $cit) $citations[] = $cit['id_citation'];
		$it_citations = new clicnat_iterateur_citations($this->db, $citations);

		$this->assign('n', $extraction->compte());
		$this->assign_by_ref('citations', $it_citations);
	}

	protected function before_validation_photo() {
		if (!isset($_SESSION['valid_ph_classe']))
			$_SESSION['valid_ph_classe'] = false;

		if (!isset($_SESSION['valid_ph_ordre']))
			$_SESSION['valid_ph_ordre'] = false;

		if (array_key_exists('accept', $_GET)) {
			$doc = new bobs_document($_GET['accept']);
			$doc->enlever_en_attente();
			unset($doc);
			header('Location: ?t=validation_photo');
			exit();
		} else if (array_key_exists('reject', $_GET)) {
			$doc = new bobs_document($_GET['reject'], $this->db);
			$doc->enlever_en_attente();
			$esp = $doc->get_doc_espece();
			$esp->document_enlever($doc->get_doc_id());
			header('Location: ?t=validation_photo');
			exit();
		} else if (array_key_exists('redim', $_GET)) {
			$doc = new bobs_document_image($_GET['doc_id'], $this->db);
			$doc->decoupe_original($_GET['largeur_travail'], $_GET['x'], $_GET['y'], $_GET['x2'], $_GET['y2']);
			header('Location: ?t=validation_photo');
			exit();
		} else if (array_key_exists('restore', $_GET)) {
			$doc = new bobs_document_image($_GET['restore'], $this->db);
			$doc->restore();
			header('Location: ?t=validation_photo');
			exit();
		} else if (array_key_exists('ordre', $_GET)) {
			$_SESSION['valid_ph_ordre'] = $_GET['ordre'];
			$this->redirect('?t=validation_photo');
		} else if (array_key_exists('classe', $_GET)) {
			$_SESSION['valid_ph_classe'] = $_GET['classe'];
			$this->redirect('?t=validation_photo');
		}
		$docs = bobs_document::liste_en_attente($this->db);
		if (!$_SESSION['valid_ph_classe']) {
			$classes = array();
			foreach ($docs as $doc) {
				$espece = $doc->get_doc_espece();
				if ($espece) {
					$classes[$espece->classe] += 1;
				}
			}
			foreach ($classes as $k => $v) {
				$classes[$k] = array(
					"lib"=>bobs_espece::get_classe_lib_par_lettre($k),
					"n"=>$classes[$k]
				);
			}
			$this->assign_by_ref("classes", $classes);
		} else {
			$ordres = array();
			foreach ($docs as $doc) {
				$espece = $doc->get_doc_espece();
				if ($espece && $espece->classe == $_SESSION['valid_ph_classe']) {
					$ordres[$espece->ordre] += 1;
			}
		}
		$this->assign_by_ref("ordres", $ordres);
	}
	$this->assign('ordre', $_SESSION['valid_ph_ordre']);
	$this->assign('classe', $_SESSION['valid_ph_classe']);
	$this->assign_by_ref('liste', $docs);
}

protected function before_extraction() {
	$id_utilisateur = $_SESSION[SESS]['id_utilisateur'];
	$reset = isset($_GET['act'])?$_GET['act']=='reset':false;
	if (empty($_SESSION[SESS]['extraction']) or $reset)
		$_SESSION[SESS]['extraction'] = new bobs_extractions($this->db);
		if (array_key_exists('charger', $_GET)) {
			if (array_key_exists('id_utilisateur', $_GET)) {
				$u2 = get_utilisateur($this->db, $_GET['id_utilisateur']);
			} else  {
				$u2 = get_utilisateur($this->db, $_SESSION[SESS]['id_utilisateur']);
			}
			$_SESSION[SESS]['extraction'] = $u2->extraction_charge_sans_restrictions($_GET['charger']);
		}

		if (isset($_POST['xml'])) {
			$_SESSION[SESS]['extraction'] = bobs_extractions::charge_xml($this->db, $_POST['xml']);
		}

		$extract = $_SESSION[SESS]['extraction'];
		// il est perdu dans la session
		$extract->set_db($this->db);
		$u = get_utilisateur($this->db, $id_utilisateur);
		$this->assign_by_ref('u', $u);
		$this->assign_by_ref('extract', $extract);

		if (isset($_GET['classe']))
			switch ($_GET['classe']) {
				case bobs_ext_c_zps::class:
					$espaces_zps = bobs_espace_zps::get_list($this->db);
					$this->assign_by_ref('espaces_zps', $espaces_zps);
					break;
				case bobs_ext_c_zsc::class:
					$espaces_zsc = bobs_espace_zsc::get_list($this->db);
					$this->assign_by_ref('espaces_zsc', $espaces_zsc);
					break;
				case bobs_ext_c_ordre::class:
					$ordres = bobs_espece::get_ordres($this->db);
					$this->assign_by_ref('ordres', $ordres);
					break;
				case bobs_ext_c_epci::class:
					$espace_epci = bobs_espace_epci::get_list($this->db);
					$this->assign_by_ref('espaces_epci', $espace_epci);
					break;
				case bobs_ext_c_liste_especes::class:
					$liste_a = clicnat_listes_especes::liste_public($this->db);
					$liste_b = clicnat_listes_especes::liste($this->db, $u->id_utilisateur);
					$this->assign_by_ref('liste_public', $liste_a);
					$this->assign_by_ref('liste_perso', $liste_b);
					break;
				case bobs_ext_c_tag_protocole::class:
					$this->assign_by_ref('protocoles', get_config()->protocoles());
					break;
				case bobs_ext_c_classe::class:
					$classes = [];
					foreach (bobs_classe::get_classes() as $c) {
						$classe = new bobs_classe($this->db, $c);
						$classes[] = [
							"id" => $c,
							"lib" => $classe->__toString()
						];
					}
					$this->assign_by_ref('classes', $classes);
					break;
				case bobs_ext_c_reseau::class:
					$this->assign_by_ref('reseaux', bobs_reseaux_liste($db));
					break;
				case bobs_ext_c_structure::class:
					$espace_structure = bobs_espace_structure::get_list($this->db);
					$this->assign_by_ref('espaces_structure', $espace_structure);
					break;
				case bobs_ext_c_tag_structure::class:
					$this->assign_by_ref('structures', get_config()->structures());
					break;
				case bobs_ext_c_departement::class:
					$l_depts = explode(',',DEPARTEMENTS);
					$depts = [];
					foreach ($l_depts as $dept) {
						$depts[] = new bobs_espace_departement($this->db, $dept);
					}
					$this->assign_by_ref('departements', $depts);
					break;
			}
			if (isset($_GET['act'])) switch ($_GET['act']) {
					case 'condition_retirer':
						$this->assign('act', 'condition_retirer');
						$extract->retirer_condition(bobs_element::cli($_GET['n']));
						break;
					case 'condition_ajoute':
						$this->assign('act', 'condition_ajoute');
						$this->assign('cl', end(explode("\\",$_GET['classe'])));
						break;
					case 'condition_enreg':
						$conditions = bobs_extractions::get_conditions_dispo(true);
						$classe = "Picnat\\Clicnat\\ExtractionsConditions\\{$_POST['classe']}";
						if (!array_key_exists($classe, $conditions)) {
							throw new \Exception("classe non gérée ici $classe");
						}
						$for_eval = "return $classe::new_by_array(\$_POST);";
						$cond = eval($for_eval);
						$extract->ajouter_condition($cond);
						break;
					case 'selection_new':
						$u = new bobs_utilisateur($this->db, $_SESSION[SESS]['id_utilisateur']);
						bobs_element::cls($_POST['sname']);
						if (empty($_POST['sname']))
							throw new \Exception('Nom de la sélection vide');
						$id_selection = $u->selection_creer($_POST['sname']);
						$extract->dans_selection($id_selection);
						$this->assign('id_selection', $id_selection);
						$this->assign('act', 'selection_new');
						break;
		}
	}

	protected function selection_utilisateur_set($obj_utilisateur) {
		$_SESSION[UTLSEL] = $obj_utilisateur->id_utilisateur;
		$_SESSION[UTLSEL_NOM] = $obj_utilisateur->nom.' '.$obj_utilisateur->prenom;
	}

	protected function selection_utilisateur_get($nom = false) {
		if ($nom) {
			if (array_key_exists(UTLSEL_NOM, $_SESSION))
				return $_SESSION[UTLSEL_NOM];
		} else {
			if (array_key_exists(UTLSEL, $_SESSION))
				return $_SESSION[UTLSEL];
		}
		return false;
	}

	protected function session() {
		session_start();
		$etat = array_key_exists(SESS, $_SESSION)?$_SESSION[SESS]['auth_ok'] == true:false;
		$this->assign('auth_ok', $etat);
		return $etat;
	}

	protected function before_plot_data() {
		$serie = array();
		if (isset($_GET['serie'])) {
			switch ($_GET['serie']) {
				case 'citations_crees_par_jour':
					$serie = bobs_citation::stats_creation_par_jour($this->db, 30);
					break;
				case 'citations_par_jour':
					$serie = bobs_citation::stats_citations_par_jour($this->db, 30);
					break;
			}
		}
		echo json_encode($serie);
		exit();
	}
	protected function before_accueil() {
		if (isset($_GET['deco'])) {
			$this->ajoute_alerte('info', 'Vous avez été déconnecté');
		}
		if (array_key_exists('act', $_POST) && $_POST['act'] == 'login') {
			if (empty($_POST['username']))
				return;
			$u = bobs_utilisateur::by_login($this->db, $_POST['username']);
			if ($u && $u->auth_ok($_POST['password']) && $u->acces_qg_ok()) {
				$this->assign('username', $u->username);
				$this->assign('id_utilisateur', $u->id_utilisateur);
				$this->assign('auth_ok', true);
				$this->assign('messageinfo', 'Bienvenue');
				$_SESSION[SESS]['auth_ok'] = true;
				$_SESSION[SESS]['id_utilisateur'] = $u->id_utilisateur;
			} else {
				$_SESSION[SESS]['auth_ok'] = false;
				$this->assign('auth_ok', false);
				$this->assign('messageinfo', "Nom d'utilisateur ou mot de passe incorrect");
			}
		} else if (isset($_GET['logout'])||(isset($_GET['fermer']))) {
			$this->assign('auth_ok', false);
			$this->ajoute_alerte('info', 'Vous avez fermé votre session');
			$_SESSION[SESS]['auth_ok'] = false;
		}
		if (isset($_SESSION[SESS]['auth_ok']) && $_SESSION[SESS]['auth_ok']) {
			$this->assign('nb_citations', bobs_citation::nombre_citations($this->db));
			$this->assign('derniers_comptes', bobs_utilisateur::derniers_comptes($this->db, 10));
			$this->assign('dernieres_especes', bobs_espece::derniers_ajouts($this->db, 10));
		}
	}

	protected function before_espece_deplacer() {
		$orig = get_espece($this->db, (int)$_GET['id']);
		$etape = 1;
		$this->assign_by_ref('orig', $orig);
		$this->assign_by_ref('etape', $etape);

		if (!empty($_POST['id_destination'])) {
			$etape = 2;
			$dest = get_espece($this->db, (int)$_POST['id_destination']);
			$this->assign_by_ref('dest', $dest);
			if ($_POST['confirmation'] == 1) {
				$etape = 3;
				$orig->change_citations_id_espece($dest->id_espece);
			}
		}
	}

	protected function before_espece_niveau_restitution() {
		self::cli($_GET['id']);
		self::cli($_GET['niveau']);
		$espece = get_espece($this->db, $_GET['id']);
		if ($_GET['inverse'] == "1") {
			if ($espece->get_restitution_ok($_GET['niveau'])) {
				$espece->del_niveau_restitution($_GET['niveau']);
			} else {
				$espece->add_niveau_restitution($_GET['niveau']);
			}
		}
		if ($espece->get_restitution_ok($_GET['niveau'])) {
			echo "1";
		} else {
			echo "0";
		}
		exit();
	}

	protected function before_espace_point_id_json()
	{
		$e = new bobs_espace_point($this->db, sprintf("%d", $_GET['id']));
		$this->assign('json', $e->exportJSON('point', $e->geom));
	}

	protected function before_espace_detail()
	{
		$espace = new bobs_espace_point($this->db, sprintf("%d", $_GET['id']));
		$this->assign('esp', $espace);
		$this->assign('observations', $espace->getObservations(true));
	}

	protected function before_espace_point_dans_zone()
	{
		$espaces = bobs_espace::get_espaces_in_poly($this->db, 'point', $_GET['zone']);

		$vr = '';
		foreach ($espaces as $e)
			$vr.= $e->exportJSON('point').',';

		$this->assign('json', sprintf("Array(%s null);", $vr));
	}

	protected function before_espace_index()
	{
		$this->assign('usemap', true);
	}

	protected function before_observateur_nouveau()
	{
		if (!empty($_POST['nom'])) {
			if (bobs_utilisateur::nouveau($this->db, $_POST)) {
				$this->assign('messageinfo', "Nouvel {$_POST['nom']} {$_POST['prenom']} utilisateur enregistré");
			} else {
				$this->assign('messageinfo', "Erreur d'enregistrement ! Vérifier les données du formulaire.".pg_last_error());
				foreach (array('nom','prenom','username','tel','port','fax', 'pwd1', 'pwd2') as $v)
					$this->assign($v, $_POST[$v]);
			}

		}
	}

	protected function before_observateurs_liste() {
		$liste = bobs_utilisateur::tous($this->db);
		$this->assign('utilisateurs', $liste);
		$this->assign('nombre', count($liste));

	}

	protected function before_observateur_selections() {
		$u = new bobs_utilisateur($this->db, $_GET['id']);
		$this->assign('utl',$u);
	}

	protected function before_observateur_modifier() {
		$the_id = false;
		if (!empty($_POST['id_utilisateur']))
			$the_id = sprintf("%d", $_POST['id_utilisateur']);
		else if (!empty($_GET['id']))
			$the_id = sprintf("%d", $_GET['id']);

		if (!$the_id)
			die("pas d'argument !");

		$u = new bobs_utilisateur($this->db, sprintf("%d", $the_id));

		if (!empty($_POST['doModif']))
			$u->modifier($_POST);

		$this->assign('u', $u);
	}

	protected function before_observateur_recherche()
	{
		$resultats = array();
		$msg = '';
		if (!empty($_GET['restreint'])) {
			$msg = 'Observateurs en diffusion restreinte';
			$resultats = bobs_utilisateur::restreint($this->db);
		} else if (!empty($_GET['reglement_ok'])) {
			$msg = 'Observateurs ayant accepté le réglement intérieur';
			$resultats = bobs_utilisateur::liste_reglement_ok($this->db);
		} else if (!empty($_POST['critere_id'])) {
			header("location: ?t=profil&id={$_POST['critere_id']}");
			exit();
		} else if (!empty($_POST['critere_nom'])) {
			$msg = 'Recherche par nom';
			$this->assign('critere_nom', $_POST['critere_nom']);

			if (!empty($_POST['critere_prenom']))
				$this->assign('critere_prenom', $_POST['critere_prenom']);

			$resultats = bobs_utilisateur::rechercher($this->db, array(
					'nom' => $_POST['critere_nom'],
					'prenom' => $_POST['critere_prenom']));
		}
		$this->assign('nombre_r', count($resultats));
		if (count($resultats) == 0) {
			$this->assign('messageinfo', 'Aucun résultat');
		} else {
			$this->assign_by_ref('resultats', $resultats);
			$this->assign('messageinfo', $msg.' - '.count($resultats).' résultats');
		}
	}

	protected function before_observateur_assoc()
	{
		if (empty($_GET['job'])) {
			$this->assign('msg', 'ajout ou retrait ?');
			return;
		}

		$id = sprintf('%d', $_GET['id']);
		if (empty($_GET['id'])) {
			$this->assign('msg', 'quel observateur ?');
			return;
		}

		if (empty($_SESSION[UTLSEL])) {
			$this->assign('msg', 'pas de sélection');
			return;
		}

		$u = new bobs_utilisateur($this->db, $_SESSION[UTLSEL]);
		$u2 = new bobs_utilisateur($this->db, sprintf('%d',$_GET['id']));
		if ($_GET['job'] == 'ajout') {
			$u->associations_add_id($id);
			$this->assign('msg', "Association avec {$u2->nom} {$u2->prenom} enregistrée");
		} else if ($_GET['job'] == 'retr') {
			if ($u->associations_remove_id($id))
				$this->assign('msg', "Retrait de l'association '.
						'avec {$u2->nom} {$u2->prenom} enregistrée");
			else
				$this->assign('msg', "Erreur lors du retrait");
		} else {
			$this->assign('msg', 'Ne sait pas quoi faire !');
		}
	}

	protected function before_observateurs_qg() {
		$liste = bobs_utilisateur::liste_qg($this->db);
		$this->assign_by_ref('utilisateurs', $liste);
	}

	protected function before_profil_photos() {
		bobs_utilisateur::cli($_GET['id']);
		$u = new bobs_utilisateur($this->db, $_GET['id']);
		$this->assign_by_ref('u', $u);
	}

	protected function before_extraction_donnees_utilisateur() {
		$obs = get_utilisateur($this->db, $_GET['id_utilisateur']);
		$extraction = new bobs_extractions($this->db);
		$extraction->ajouter_condition(new bobs_ext_c_observateur($_GET['id_utilisateur']));
		$u = new bobs_utilisateur($this->db, $_SESSION[SESS]['id_utilisateur']);
		$id_selection = $u->selection_creer("Observations de $obs au ".strftime("%d-%m-%Y"));
		$extraction->dans_selection($id_selection);
		header('Location: ?t=selection&id='.$id_selection);
		exit();
	}

	protected function before_extraction_donnees_utilisateur_non_validees() {
		$obs = get_utilisateur($this->db, $_GET['id_utilisateur']);
		$extraction = new bobs_extractions($this->db);
		$extraction->ajouter_condition(new bobs_ext_c_observateur($_GET['id_utilisateur']));
		$extraction->ajouter_condition(new bobs_ext_c_tag(579));
		$u = new bobs_utilisateur($this->db, $_SESSION[SESS]['id_utilisateur']);
		$id_selection = $u->selection_creer("Observations de $obs au ".strftime("%d-%m-%Y"));
		$extraction->dans_selection($id_selection);
		header('Location: ?t=selection&id='.$id_selection);
		exit();
	}

	protected function before_profil($u=false) {
		bobs_utilisateur::cli($_GET['id']);

		if (!$u)
			$u = new bobs_utilisateur($this->db, $_GET['id']);

		if (isset($_GET['enlever_statut_junior']))
			$u->set_junior(false);

		elseif (isset($_GET['virtuel_update']))
			$u->update_statut_virtuel(!$u->virtuel);

		elseif (isset($_GET['migration_observations_owned']))
			$u->migration_observations_owned();

		elseif (isset($_GET['migration_observations_dispatch']))
			$u->migration_observation_dispatch();

		elseif (isset($_POST['nom_zone']))
			$u->ajoute_carre_atlas($_POST['nom_zone'], $_POST['decideur_aonfm']==1);

		elseif (isset($_GET['supprime_carre']))
			$u->supprime_carre_atlas($_GET['supprime_carre']);

		elseif (isset($_GET['ajout_ref_tiers']))
			$u->ajout_reference_tiers($_GET['ajout_ref_tiers'], $_GET['id_tiers']);

		elseif (isset($_GET['supprime_ref_tiers']))
			$u->supprime_reference_tiers($_GET['supprime_ref_tiers'], $_GET['id_tiers']);

		elseif (isset($_GET['raz_mad']))
			$u->mise_a_dispo_vide();

		elseif (isset($_POST['xml_add_mad']))
			$u->extraction_ajoute($_POST['xml_add_mad'], true);

		elseif (isset($_POST['retirer_extraction']))
			$u->extraction_supprime($_GET['retirer_extraction']);

		elseif (isset($_GET['expert']))
			$u->set_expert(!$u->expert);

		elseif (isset($_GET['peut_ajouter_espece']))
			$u->set_peut_ajouter_espece(!$u->peut_ajouter_espece);

		elseif (isset($_POST['set_id_gdtc']))
			$u->set_id_gdtc((int)$_POST['set_id_gdtc']);
		elseif (isset($_POST['prop_k']) && isset($_POST['prop_v'])) {
			$u->prop($_POST['prop_k'], $_POST['prop_v']);
			$this->redirect("?t=profil&id={$u->id_utilisateur}");
		}

	//	$u->get_nb_observations();
	//	$u->get_especes_vues();
		$u->get_premiere_date_obs();
		$u->get_derniere_date_obs();
		$this->assign_by_ref('u', $u);
		$this->assign('est_selection', $this->selection_utilisateur_get() == $u->id_utilisateur);
	}

	protected function before_observateur_selectionner() {
		$u = new bobs_utilisateur($this->db, sprintf("%d", $_GET['id']));
		$this->selection_utilisateur_set($u);
		$this->before_profil($u);
	}

	protected function before_monprofil() {
		$u = new bobs_utilisateur($this->db, $_SESSION[SESS]['id_utilisateur']);
		$this->assign('u', $u);
	}

	protected function before_commune_index() {
		if (!empty($_POST['critere_nom'])) {
			$r = bobs_commune::rechercher($this->db, array('nom'=> $_POST['critere_nom']));
			$this->assign('communes', $r);
			$this->assign('resultat_recherche', true);
			$this->assign('critere_nom', $_POST['critere_nom']);
		} else {
			$communes = bobs_commune::get_all($this->db);
			$this->assign('communes', $communes);
			$this->assign('resultat_recherche', false);
		}
	}

	protected function before_commune_detail() {
		bobs_commune::cli($_GET['id']);
		$this->assign_by_ref('commune', get_espace_commune($this->db, $_GET['id']));
	}

	protected function before_statistique_saisie()
	{
		// famille
		if (!empty($_POST['f']))
			$famille = sprintf('%s', $_POST['f']);
		else
			$famille = false;

		// département
		if (!empty($_POST['d'])) {
			$departement = sprintf('%d', $_POST['d']);
			$dept = new bobs_departement($this->db, $departement);
		} else {
			$departement = false;
			$dept = false;
		}

		$stats = bobs_observation::get_statistique_saisie($this->db, $famille, $departement);
		$totaux_mois = array();
		$totaux_annees = array();

		foreach ($stats as $annee => $mois) {
			$total_annee = 0;
			foreach ($mois as $m => $v) {
				$total_annee += $v;
				$totaux_mois[$m] += $v;
			}
			$stats[$annee]['total'] = $total_annee;
		}
		$this->assign('departements', bobs_departement::get_liste($this->db));
		$this->assign('departement', $departement);
		$this->assign('departement_obj', $dept);
		$this->assign('famille', $famille);
		$this->assign('stats', $stats);
		$this->assign('totaux_mois', $totaux_mois);
	}

	protected function before_especes_index()
	{
		if (!empty($_POST['maj_nidif'])) {
			foreach ($_POST as $k=>$v) {
				if (!empty($v)) {
					if (preg_match('/^jour_debut_nidif_(.*)$/', $k, $matches)) {
						$id = (int)$matches[1];
						$esp = new bobs_espece($this->db, $id);
						$esp->modifier_date_nidif(
							$_POST['jour_debut_nidif_'.$id],
							$_POST['mois_debut_nidif_'.$id],
							$_POST['jour_fin_nidif_'.$id],
							$_POST['mois_fin_nidif_'.$id]);
					}
				}
			}
		}
		$this->assign('nom', bobs_espece::get_classe_lib_par_lettre($_GET['classe']));
		$this->assign('especes', bobs_espece::get_liste_par_classe($this->db, $_GET['classe'], !($_GET['tous'] == 1)));
		$this->assign('classe', $_GET['classe']);
		$this->assign('tous', $_GET['tous'] == 1);
	}

	protected function before_espece_details_tags()
	{
		$espece = new bobs_espece($this->db, $_GET['id']);
		$this->assign_by_ref('espece', $espece);
	}

	protected function before_espece_details_referentiel_region()
	{
		$espece_id = bobs_element::cli($_GET['id']);

		if (empty($espece_id)) {
			throw new \Exception('Le numéro espèce est vide');
		}
		$espece = new bobs_espece($this->db, $espece_id);

		if (!empty($_POST['statut_origine'])) {
			$espece->update_referentiel_regional($_POST);
		}
		$this->assign_by_ref('espece', $espece);
		$this->assign_by_ref('oldref', $espece->get_referentiel_pn());
		$this->assign_by_ref('ref_region', $espece->get_referentiel_regional());
	}

	protected function before_espece_details_taxonomie() {
		$espece = new bobs_espece($this->db, $_GET['id']);
		if (empty($espece->id_espece))
			throw new \Exception('pas trouvé');
		$espece_inpn = $espece->get_inpn_ref();
		$this->assign_by_ref('espece', $espece);
		$this->assign_by_ref('inpn', $espece_inpn);
	}

	protected function before_observation() {
		$obs = new bobs_observation($this->db, $_GET['id']);
		$this->assign_by_ref('obs', $obs);
	}

	protected function before_espece_supprimer() {
	    $esp = get_espece($this->db, $_GET['id']);
	    $this->assign_by_ref('esp', $esp);
	    if ($_GET['confirm'] == 1) {
				$index = $esp->classe;
				$esp->supprimer();
				header('Location: ?t=especes_index&classe='.$index);
	    }
	}

	protected function before_espece_detail() {
		$esp = get_espece($this->db, (int)$_GET['id']);

		if (isset($_GET['maj_carte_repartition'])) {
			$esp->atlas_repartition_maj();
			$this->ajoute_alerte("info","cartes de répartitions (mailles) mises à jour");
			$this->redirect("?t=espece_detail&id={$esp->id_espece}");
		}
		if (isset($_POST['gbif_lookup'])) {
			$gbif = new clicnat_gbifapi();
			$gbif_r = $gbif->species_match([
				"name" => $esp->nom_s,
				"rank"=>"SPECIES"
			]);
			$gbif_ids = [$gbif_r->speciesKey];
			if (count($gbif_ids) == 1) {
				try {
					$esp->ajoute_reference_tiers("gbif", $gbif_ids[0]);
				} catch (\Exception $e) {
					print_r($gbif_r);
				}
				$this->ajoute_alerte('info', "Taxon associé avec id gbif {$gbif_ids[0]}");
			} else if (count($gbif_ids) > 1) {
				$this->ajoute_alerte('info', "Recherche GBIF trop de résultats");
				foreach ($gbif_r->results as $tg) {
					$path = "{$tg['kingdom']}/{$tg['phylum']}/{$tg['order']}";
					$rank = $tg['rank'];
					$scname = $tg['scientificName'];
					$this->ajoute_alerte("info","
						<form method=\"post\" action=\"?t=espece_detail&id={$esp->id_espece}\">
							Rang : $rank $path <b>$scname</b>
							<input type=hidden name=tiers value=gbif>
							<input type=hidden name=id_tiers value={$tg['nubKey']}</input>
							<button class=\"btn-primary btn-xs\">Associer {$tg['nubKey']}</button>

						</form>

					");
				}
			} else {
				$this->ajoute_alerte('info', "Recherche GBIF pas de correspondance");
			}
			$this->redirect("?t=espece_detail&id={$esp->id_espece}");
		}

		if (isset($_POST['id_espece_parent'])) {
			$esp->set_id_espece_parent($_POST['id_espece_parent']);
		}

		if (isset($_POST['del_id_tiers']) && isset($_POST['del_tiers'])) {
			if ($esp->supprime_reference_tiers($_POST['del_tiers'],$_POST['del_id_tiers']))
				$this->redirect("?t=espece_detail&id={$esp->id_espece}");
		}
		if (isset($_POST['id_tiers']) && isset($_POST['tiers'])) {
			if ($esp->ajoute_reference_tiers($_POST['tiers'], $_POST['id_tiers']))
				$this->redirect("?t=espece_detail&id={$esp->id_espece}");
		}
		if (isset($_POST['id_chr'])) {
			if ($_POST['id_chr'] == 'aucun')
				$esp->set_chr(0);
			else if (!$esp->set_chr($_POST['id_chr'])) {
				throw new \Exception('Problème mise à jour CHR');
			}
		}

		if (bobs_element::cli($_GET['atlas'], BOBS_CLI_NO_EX))
			$esp->active_atlas();

		if (bobs_element::cli($_GET['stopatlas'], BOBS_CLI_NO_EX))
			$esp->stop_atlas();

		if (isset($_POST['mise_a_jour']))
			$esp->modifier($_POST);

		if (isset($_GET['associer_mnhn']))
			$esp->associer_taxref((int)$_GET['associer_mnhn']);

		if (isset($_GET['retirer_mnhn']))
			$esp->enlever_taxref();

		if (!empty($esp->taxref_inpn_especes)) {
			$this->assign('inpn_libs', bobs_espece_inpn::get_prop_libs());
			$this->assign('inpn', $esp->get_inpn_ref());
		} else {
			$tinpn = bobs_espece_inpn::recherche_pour_espece_fnat($this->db, $esp);
			$this->assign('inpn_n', count($tinpn));
			$this->assign('inpn_t', $tinpn);
		}
		$esp->get_classe_lib();
		//$esp->get_referentiel_pn();
		$liste_chr = bobs_chr::get_list($this->db);
		$this->assign_by_ref('liste_chr', $liste_chr);
		$this->assign_by_ref('esp', $esp);
	}

	protected function before_espece_ajoute_photo() {
		$espece = get_espece($this->db, $_POST['id_espece']);
		$doc_id = bobs_document::sauve($_FILES['f']);
		$image = new bobs_document_image($doc_id);
		$image->ajoute_auteur($_POST['auteur'], $_POST['id_utilisateur']);
		$espece->document_associer($doc_id);
		header('Location: ?t=espece_detail&id='.$espece->id_espece);
		exit();
	}

	protected function before_audio() {
		$doc = new bobs_document_audio($_GET['id']);
		$doc->get_audio();
		exit();
	}

	protected function before_espece_supprime_doc() {
		$esp = get_espece($this->db, (int)$_GET['id_espece']);
		if ($esp)
			$esp->document_enlever($_GET['doc_id']);
		$this->redirect("?t=espece_detail&id={$_GET['id_espece']}");
	}

	protected function before_img() {
		$w = isset($_GET['w'])?(int)$_GET['w']:0;
		$h = isset($_GET['h'])?(int)$_GET['h']:0;
		$im = new bobs_document_image($_GET['id']);
		if (empty($w) && empty($h)) {
			$im->get_image();
		} else {
			$im->get_image_redim($w,$h);
		}
		exit();
	}

	protected function before_espece_modifier() {
		// enregistrement du formulaire dans espece_detail
		$esp = new bobs_espece($this->db, $_GET['id']);
		$this->assign_by_ref('e', $esp);
	}

	protected function before_espece_nouveau() {
		if (!empty($_GET['saveme']))
			bobs_espece::insert($this->db, $_POST);
	}

	protected function before_espece_details_communes_pre() {
		if (empty($_GET['id'])) die('id?');
		$esp = new bobs_espece($this->db, sprintf('%d', $_GET['id']));
		$l = $esp->liste_communes_presentes();
		$this->assign('liste',$l);
		$this->assign('n', count($l));
	}

	protected function before_espece_details_citations_par_mois() {
		if (empty($_GET['id'])) die('id?');
		$esp = new bobs_espece($this->db, sprintf('%d', $_GET['id']));
		$l = $esp->citations_par_mois();
		$this->assign('liste',$l);
		$this->assign('n', count($l));
	}

	protected function before_espece_details_observations()
	{
		if (empty($_GET['id'])) die('id?');
		$esp = new bobs_espece($this->db, sprintf('%d', $_GET['id']));
		$l = $esp->get_observations(true);
		$this->assign('observations',$l);
		$this->assign('surligner_espece', $esp->id_espece);
	}

	protected function before_especes_import_ref_pn($oiseaux=false)
	{
		$liste = bobs_referentiel::get_all($this->db, true, $oiseaux);
		$action = $oiseaux?'especes_import_ref_pn_oiseaux':'especes_import_ref_pn';
		$this->assign('action',$action);

		foreach ($liste as $k=>$e) {
			if (!empty($e->nom_sc)) {
				$liste[$k]->tr = bobs_espece::index_recherche($this->db, $e->nom_sc);
				$liste[$k]->tr2 = bobs_espece_inpn::index_recherche($this->db, $e->nom_sc);
			}
			if (!empty($_GET['id_espece']) && !empty($_GET['id_import'])) {
				if ($liste[$k]->id_import == $_GET['id_import'])
					$liste[$k]->set_id_espece($_GET['id_espece']);
			}
			if (!empty($_POST['id_import']) && !empty($_POST['nom_sc'])) {
				if ($liste[$k]->id_import == $_POST['id_import'])
					$liste[$k]->set_nom($_POST['nom_sc']);
			}
			if (!empty($_GET['id_import']) && !empty($_GET['cd_nom'])) {
				if ($liste[$k]->id_import == $_GET['id_import'])
					$liste[$k]->set_cd_nom($_GET['cd_nom']);
			}
		}
		$this->assign('lref',$liste);
	}

	protected function before_especes_import_ref_pn_oiseaux()
	{
		$this->before_especes_import_ref_pn(true);
	}

	protected function before_referentiel_regional()
	{
		$especes = bobs_espece::get_especes_dans_referentiel($this->db);

		$this->assign_by_ref('especes', $especes);
	}

	protected function before_import_nouveau()
	{
		$nom_fichier = sprintf("/tmp/%s.csv", uniqid('import_'));
		if (!move_uploaded_file($_FILES['fichier']['tmp_name'], $nom_fichier)) {
			throw new \Exception('une erreur a eu lieu lors de l\'envoi du fichier');
		}
		print_r($_POST);
		$id_import = bobs_import::nouveau($this->db, array(
				'id_utilisateur' => $_POST['id_utilisateur'],
				'id_auteur' => $_POST['id_utilisateur'],
				'libelle' => $_POST['lib']
			));
		if (!$id_import)
			throw new \Exception('échec de l\'import lors de la création de celui-ci');
		$import = new bobs_import($this->db, $id_import);
		$n_ligne = $import->charge_fichier($nom_fichier);
		$this->assign('messageinfo', $n_ligne.' ligne(s) importée(s)');
	}

	protected function before_tags() {
		if (isset($_POST['action']))
		switch($_POST['action']) {
			case 'nouveau':
				bobs_element::cli($_POST['parent_id'], false);
				$_GET['root'] = $_POST['parent_id'];
				bobs_tags::insert_node($this->db, $_POST['parent_id'], $_POST['lib'], $_POST['ref'], !empty($_POST['categorie_simple']));
				break;
			case 'maj':
				$ks = array('lib','ref','parent_id','a_chaine','a_entier','categorie_simple','classes_esp_ok');
				$tag = new bobs_tags($this->db, $_GET['root']);
				foreach ($ks as $k) {
					if ($tag->$k != $_POST[$k]) {
						$tag->update($k, $_POST[$k]);
					}
				}
				break;
		}
		if (!isset($_GET['root']) || empty($_GET['root'])) {
			$tags = bobs_tags::get_roots($this->db);
			$this->assign('tag', false);
		} else {
			bobs_element::cli($_GET['root'], false);
			$tag = new bobs_tags($this->db, $_GET['root']);
			$tags = $tag->get_childs();
			$this->assign_by_ref('tag', $tag);
		}
		$this->assign_by_ref('tags', $tags);
		$this->assign('root', isset($_GET['root'])?$_GET['root']:false);
	}

	protected function before_tags_deplace()
	{
		$tag = new bobs_tags($this->db, $_GET['sid']);
		$tag->set_parent($_GET['tid']);
	}

	protected function before_selections()
	{
		$selections = bobs_selection::liste_qg($this->db);

		$this->assign_by_ref('selections_qg', $selections);
		$u = new bobs_utilisateur($this->db, $_SESSION[SESS]['id_utilisateur']);
		$mes_selections = $u->selections();
		$this->assign_by_ref('mes_selections', $mes_selections);
	}

	protected function before_selection()
	{
		$selection = new bobs_selection($this->db, $_GET['id']);
		foreach ($_GET as $k => $v) {
			if (preg_match('/^retirer_(\d+)/', $k, $m)) {
				$selection->enlever($m[1]);
			}
		}
		$this->assign_by_ref('s', $selection);
	}

	protected function before_selection_info() {
		$selection = new bobs_selection($this->db, $_GET['id']);
		$this->assign_by_ref('structures', clicnat_structure::structures($this->db));
		$this->assign_by_ref('protocoles', clicnat_protocoles::liste($this->db));
		$this->assign_by_ref('s', $selection);
		if (isset($_GET['do'])) {
			switch ($_GET['do']) {
				case 'valider':
					$utl_valid = new bobs_utilisateur($this->db, $_GET['id_valid']);
					$n = 0;
					foreach ($selection->tab_citations() as $t_citation) {
						$citation = get_citation($this->db, $t_citation['id_citation']);
						$citation->validation($utl_valid->id_utilisateur);
						$n++;
					}
					$this->ajoute_alerte('info', "$n citations traitées");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'changer_proprio':
					$utl = new bobs_utilisateur($this->db, $_GET['id_utilisateur']);
					$selection->change_proprietaire($utl->id_utilisateur);
					$selection->set_qg();
					$this->ajoute_alerte('info', "Nouveau propriétaire : $utl");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'tache_dl_csv':
					$utilisateur = get_utilisateur($this->db, $_SESSION[SESS]['id_utilisateur']);
					$tache = $selection->creer_tache_fichier_csv($utilisateur);
					$this->ajoute_alerte('info', "Tache #$tache créée");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'ajouter_ids':
					$ids = array();
					foreach (explode("\n",$_POST['ids']) as $n) {
						$x = (int)$n;
						if ($x > 0) {
							$ids[] = $x;
						}
					}
					$avant = $selection->n();
					$selection->ajouter_ids($ids);
					$apres = $selection->n();
					$diff = $apres-$avant;
					$this->ajoute_alerte('info', "$diff citation(s) ajoutée(s)");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'associer_structure':
				case 'associer_protocole':
					if (empty($_POST['txt_id']))
						throw new \Exception('manque identifiant structure');
					$tag = null;
					switch ($_GET['do']) {
						case 'associer_structure':
							$tag = bobs_tags::by_ref($this->db, 'STRU');
							break;
						case 'associer_protocole':
							$tag = bobs_tags::by_ref($this->db, 'ETUD');
							break;
						default:
							throw new \Exception('do invalide');
					}
					$n_vu = 0;
					$n_ajout = 0;
					foreach ($selection->get_citations() as $citation) {
						$n_vu++;
						$peut_ajouter = true;
						if ($citation->a_tag($tag->id_tag)) {
							foreach ($citation->get_tags() as $cit_tag) {
								if (($cit_tag['id_tag'] == $tag->id_tag) && ($cit_tag['v_text'] == $_POST['txt_id'])) {
									$peut_ajouter = false;
									break;
								}
							}
						}
						if ($peut_ajouter) {
							$citation->ajoute_tag($tag->id_tag, null, $_POST['txt_id'], $_SESSION[SESS]['id_utilisateur']);
							$n_ajout++;
						}
					}
					$this->ajoute_alerte('info', "$n_vu occurrences vues et $n_ajout étiquettes ajoutées");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'ajouter_etiquette':
					if (empty($_POST['id_tag']))
						throw new \Exception('manque identifiant tag');
					$id_tag = self::cli($_POST['id_tag']);
					$n_vu = 0;
					$n_ajout = 0;
					foreach ($selection->get_citations() as $citation) {
						$n_vu++;
						if ($citation->a_tag($id_tag))
							continue;
						$citation->ajoute_tag($id_tag, null, null, $_SESSION[SESS]['id_utilisateur']);
						$n_ajout++;
					}
					$this->ajoute_alerte('info', "$n_vu occurrences vues et $n_ajout étiquettes ajoutées");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'retirer_etiquette':
					if (empty($_POST['id_tag']))
						throw new \Exception('manque identifiant tag');
					$id_tag = self::cli($_POST['id_tag']);
					$n_vu = 0;
					$n_suppr = 0;
					foreach ($selection->get_citations() as $citation) {
						$n_vu++;
						if ($citation->a_tag($id_tag))
							$citation->supprime_tag($id_tag, $_SESSION[SESS]['id_utilisateur']);
						$n_suppr++;
					}
					$this->ajoute_alerte('info', "$n_vu occurrences vues et $n_suppr étiquettes retirées");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'invalider':
					$n_vu = 0;
					$n_inv = 0;
					foreach ($selection->get_citations() as $citation) {
						$n_vu++;
						if ($citation->invalider($_SESSION[SESS]['id_utilisateur']))
							$n_inv++;
					}
					$this->ajoute_alerte('info', "$n_vu occurrences vues et $n_inv occurences invalidées");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'remettre_en_attente':
					$n_vu = 0;
					$n_att = 0;
					foreach ($selection->get_citations() as $citation) {
						$n_vu++;
						if ($citation->remettre_en_attente($_SESSION[SESS]['id_utilisateur']))
							$n_att++;
					}
					$this->ajoute_alerte('info', "$n_vu occurrences vues et $n_att occurences remises en attente");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'fill_agent_etat':
					$selection->ajouter_ids_citation_extraction_agent($_POST['eid']);
					$this->ajoute_alert('info', "Extraction {$_POST['eid']} ajoutée");
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
				case 'vider':
					$selection->vider();
					$this->redirect('?t=selection_info&id='.$selection->id_selection);
					break;
			}
		}
	}

	protected function before_selection_csv() {
		$encoding = 'utf8';
		if (!empty($_GET['encoding']))
		    $encoding = $_GET['encoding'];
		$fh = tmpfile();
	    	$selection = new bobs_selection($this->db, $_GET['id']);
		$selection->extract_csv($fh);

		header("Content-Type: text/csv");
		header("Content-disposition: filename=clicnat_csv_extraction_{$_GET['id']}_$encoding.csv");

		fseek($fh, 0);
		while (!feof($fh)) {
			if ($encoding != 'utf8')
				echo mb_convert_encoding(fgets($fh), $encoding, 'utf8');
			else
				echo fread($fh, 8192);
		}
		fclose($fh);
		exit();
	}

	protected function before_selection_shp($type=BOBS_EXTRACT_SHP_NORMAL) {
		$s = new bobs_selection($this->db, $_GET['sel']);
		$epsg_id = $_GET['epsg_id'];
		$zip = $s->extract_shp_zip($epsg_id, $type);
		if (empty($zip))
		    throw new \Exception('$zip vide');

		header('Content-Type: application/octet-stream');
		header('Content-Disposition: attachment; filename="'."$type-{$s->id_selection}-{$epsg_id}".'.zip"');
		header('Content-Transfer-Encoding: binary');

		echo file_get_contents($zip);
		exit();
	}

	protected function before_selection_shp_atlas()
	{
	    $this->before_selection_shp(BOBS_EXTRACT_SHP_1KM);
	}

	protected function before_selection_shp_mix()
	{
	    $this->before_selection_shp(BOBS_EXTRACT_SHP_MIX);
	}

	protected function before_selection_xls()
	{
	    $s = new bobs_selection($this->db, $_GET['sel']);
	    $s->extract_xls();
	    exit();
	}

	protected function before_imports_liste() {
		if (array_key_exists('purge', $_GET)) {
			$imp = new bobs_import($this->db, $_GET['purge']);
			$imp->purge();
		}
		$liste = bobs_import::get_list($this->db);
		$this->assign_by_ref('liste', $liste);
	}

	protected function before_import_dload() {
		$imp = new bobs_import($this->db, $_GET['id']);
		header("Content-Type: application/csv-tab-delimited-table");
		header("Content-disposition: filename=import-{$imp->id_import}.csv");
		header("Content-encoding: utf8");
		$imp->export_fichier();
		exit();
	}

	protected function before_import_main() {
		$colonnes = bobs_import::liste_colonnes($this->db, true);
		$import = new bobs_import($this->db, $_GET['id']);
		if (isset($_GET['valeurs_par_defaut'])) {
			$import->set_colonnes_imports();
			$import->sauve_colonnes();
		}
		$ligne = bobs_tests::cli($_GET['ligne']);
		$ligne = $import->ligne(empty($ligne)?1:$ligne);
		$this->assign_by_ref('colonnes', $colonnes);
		$this->assign_by_ref('ligne', $ligne);
		$this->assign_by_ref('import', $import);
		$types = [
			IMPORT_COL_OBS_DATE,
			IMPORT_COL_CIT_ORDRE,
			IMPORT_COL_CIT_EFFECTIF,
			IMPORT_COL_OBS_OBSERV,
			IMPORT_COL_OBS_LIEU,
			IMPORT_COL_CIT_ESPECE,
			IMPORT_COL_IGNORER,
			IMPORT_COL_TEMPERATURE,
			IMPORT_COL_GENRE,
			IMPORT_COL_CODE_FNAT,
			IMPORT_COL_AGE,
			IMPORT_COL_COMMENTAIRE,
			IMPORT_COL_HEURE,
			IMPORT_COL_DUREE,
			IMPORT_COL_LATITUDE_DMS,
			IMPORT_COL_LONGITUDE_DMS,
			IMPORT_COL_LATITUDE_D,
			IMPORT_COL_LONGITUDE_D,
			IMPORT_COL_CD_NOM,
			IMPORT_COL_INDICE_FIA,
			IMPORT_COL_PERIODE_DATE_A,
			IMPORT_COL_PERIODE_DATE_B,
			IMPORT_COL_WKT
		];
		$this->assign_by_ref('types', $types);
	}

	protected function before_import_set_col_type() {
		$import = new bobs_import($this->db, $_GET['id_import']);
		$import->set_colonne_type($_GET['colonne'], $_GET['type']);
		$import->sauve_colonnes();
		$this->assign('nom', $import->titre_type_colonne($import->get_colonne_type($_GET['colonne'])));
	}

	protected function before_import_test_cols() {
		$import = new bobs_import($this->db, $_GET['id']);
		$t = $import->test_attribution_colonne();
		$this->assign_by_ref('import', $import);
		$this->assign_by_ref('t', $t);
	}

	protected function before_import_obs_liste() {
		$import = new bobs_import($this->db, $_GET['id']);
		$this->assign_by_ref('import', $import);
	}

	protected function before_import_obs() {
		$import = new bobs_import($this->db, $_GET['id']);
		if (isset($_GET['act']))
		switch ($_GET['act']) {
			case 'creer_observations':
				$import->get_imp_observations();
				//echo "<script>location.href='?t=import_obs&id={$_GET['id']}';</script>";
				break;
		}
		$this->assign_by_ref('import', $import);
		$this->assign('usemap', true);
	}

	protected function before_recherche_point() {
	    bobs_element::cls($_GET['term']);
	    echo bobs_espace_point::recherche($this->db, $_GET['term']);
	    exit();
	}

	protected function before_import_w_obs() {
		$import = new bobs_import($this->db, $_GET['id_import']);
		bobs_element::cls($_GET['set_nom_esp']);
		if (!empty($_GET['set_nom_esp'])) {
			$import->update_espece_str($_GET['num_ligne'], $_GET['set_nom_esp']);
		}

		if (!empty($_GET['enlever_id_utilisateur'])) {
			$obs = $import->get_observation($_GET['id_observation']);
			$obs->supprime_observateur($_GET['enlever_id_utilisateur']);
		} else if (!empty($_GET['ajouter_id_utilisateur'])) {
			$obs = $import->get_observation($_GET['id_observation']);
			$obs->ajoute_observateur($_GET['ajouter_id_utilisateur']);
		}

		$observation = new bobs_import_observations($this->db, $_GET['id_observation']);
		bobs_element::cli($_GET['id_espace']);

		if (!empty($_GET['valide'])) {
			if (!$observation->pret_a_valider()) {
				die('Pas prête');
			}
			$observation->valider();
			echo "OK <a href=?t=observation_edit&id={$observation->id_observation}>{$observation->id_observation}</a>";
			exit();
		}

		if (!empty($_GET['id_espace'])) {
			$_espace = get_espace($this->db, 'espace_point', (int)$_GET['id_espace']);
			$observation->set_espace($_espace->get_table(), $_GET['id_espace']);
		}

		$ligne1 = $import->ligne($observation->num_ligne);
		$dms = $import->extract_lat_lon_dms($ligne1) ;
		$latlon = $import->extract_lat_lon($ligne1);
		$wkt = $import->extract_wkt($ligne1);
		if ($dms) {
			if (empty($observation->id_espace)) {
				$observation->set_espace_dms($dms['latitude_dms'], $dms['longitude_dms']);
				$observation = new bobs_import_observations($this->db, $_GET['id_observation']);
			}
		} else if ($latlon) {
			if (empty($observation->id_espace)) {
				$observation->set_espace_d($latlon['latitude'], $latlon['longitude']);
			}
		} else if ($wkt) {
			if (empty($observation->id_espace)) {
				$observation->set_espace_wkt($wkt);
			}
		}

		$this->assign('dms', $dms);
		$this->assign('loc', $import->extract_location($ligne1));
		$this->assign_by_ref('import', $import);
		$this->assign_by_ref('observation', $observation);
	}

	protected function before_import_w_obs_create_citation() 	{
	    self::cli($_GET['id_observation'], true);
	    self::cli($_GET['num_ligne'], true);
	    self::cli($_GET['id_espece'], true);

	    bobs_element::query($this->db, 'begin');
	    $obs = new bobs_import_observations($this->db, $_GET['id_observation']);

	    if ($obs->citation_ligne_existe($_GET['num_ligne'])) {
		    echo "ERR(EXISTE DEJA)";
		    exit();
	    }

	    for ($i=0;$i<10;$i++) {
		if (isset($_GET['eff'.$i])) {
		    $id_cit = $obs->citation_ligne_creation($_GET['num_ligne'], $_GET['id_espece']);
		    $citation = new bobs_import_citations($this->db, $id_cit);
		    $citation->set_nb($_GET['eff'.$i]);
		    $citation->set_genre($_GET['genre'.$i]);
		    $citation->set_age($_GET['age'.$i]);
		    $citation->set_commentaire($_GET['commentaire']);
		    $citation->set_indice_qualite($_GET['indice_qualite']);
		    for ($j=0;$j<10;$j++) {
			if (isset($_GET['tag'.$j]))
			    $citation->ajoute_tag($_GET['tag'.$j]);
			else
			    break;
		    }
		    echo $id_cit."\n";
		} else {
		    break;
		}
	    }
	    bobs_element::query($this->db, 'commit');
	    exit();
	}

	// todo retirer
	protected function before_map_extract()
	{
		global $disallow_dump;
		$disallow_dump = true;
		bobs_element::cls($_GET['class'], true);
		bobs_element::cls($_GET['fond']);

		if (!in_array($_GET['fond'], array('scan25','scan100', 'scan1000', 'ortho')))
			throw new \Exception('unknown layer');

		switch ($_GET['class']) {
			case 'commune':
				$obj = new bobs_commune($this->db, $_GET['id']);
				break;
			default:
				throw new \Exception('unknown class');
		}
		$img = $obj->get_ms_img(1024, 768, $_GET['fond']);
		if (!$img)
			throw new \Exception('get_ms_img failed');
		bobmap_image_out($img);
	}

	protected function before_validation_vignette()
	{
	    $observation = new bobs_observation($this->db, $_GET['oid']);
	    $espace = $observation->get_espace();
	    $img = $espace->get_image(800, 600, 'scan25');
	    bobmap_image_out($img);
	}

	/**
	 * @deprecated
	 */
	protected function before_atlas_img() {
		$esp = new bobs_espece($this->db, $_GET['id']);
		$esp->get_atlas_img();
		exit(0);
	}

	protected function before_espece_insert_inpn() {
		if (isset($_GET['id'])) {
			$esp_inpn = new bobs_espece_inpn($this->db, (int)$_GET['id']);
			$id = $esp_inpn->insert_in_especes();
			$esp = get_espece($this->db, $id);
			if ($id) {
				$this->ajoute_alerte("success","Taxon <a href=\"?t=espece_detail&id={$esp->id_espece}\">{$esp}</a> créé (#{$esp->id_espece})");
				$this->redirect("?t=espece_insert_inpn");
				exit(0);
			}
		}
	}

	protected function before_autocomplete_observateur() {
		return $this->__before_autocomplete_observateur();
	}

	/**
	 * @deprecated
	 */
	public function before_tc() {
	    $args = $_SERVER['QUERY_STRING'];
	    $ch = curl_init();
	    $url = 'http://localhost/cgi-bin/tilecache.cgi?'.$args;
	    curl_setopt($ch, CURLOPT_URL, $url);
	    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	    $output = curl_exec($ch);
	    if (!empty($output)) {
			header('Content-type: '.curl_getinfo($ch, CURLINFO_CONTENT_TYPE));
			echo $output;
	    } else {
			echo $url;
	    }
	    curl_close($ch);
	    exit();
	}

	protected function before_citation_test_acces_utilisateur() {
		$utilisateur = get_utilisateur($this->db, (int)$_GET['id_utilisateur']);
		$citation_ok = false;
		try {
			$citation_ok = $utilisateur->get_citation_authok((int)$_GET['id_citation']);
		} catch (\Exception $e) {
			$citation_ok = false;
		}
		$this->assign_by_ref('utilisateur', $utilisateur);
		$this->assign_by_ref('citation', get_citation($this->db, (int)$_GET['id_citation']));
		$this->assign_by_ref('citation_ok', $citation_ok);
	}

	protected function before_citation_edit() {
		$id_utilisateur = $_SESSION[SESS]['id_utilisateur'];
		$citation = get_citation($this->db, $_GET['id']);
		if (array_key_exists('champ', $_POST)) {
			switch ($_POST['champ']) {
				case 'nb':
					$citation->modification($id_utilisateur, 'nb', $_POST['valeur']);
					break;
				case 'id_espece':
					$citation->modification($id_utilisateur, 'id_espece', $_POST['valeur']);
					break;
				case 'indice_qualite':
					$citation->modification($id_utilisateur, 'indice_qualite', $_POST['valeur']);
					break;
				case 'sexe':
					$citation->modification($id_utilisateur, 'sexe', $_POST['valeur']);
					break;
				case 'age':
					$citation->modification($id_utilisateur, 'age', $_POST['valeur']);
					break;
				case 'tag_supprimer':
					$citation->modification($id_utilisateur, 'tag_supprimer', $_POST['id_tag']);
					break;
				case 'tag_ajouter':
					$citation->modification($id_utilisateur, 'tag_ajouter', $_POST['id_tag']);
					break;
				default:
					throw new \Exception('champ a modifier invalide');
			}
		}
		if (isset($_POST['validation']))
		switch ($_POST['validation']) {
			case 'suppr_attv':
				$citation->validation($id_utilisateur);
				break;
			case 'suppr_attv_ajout_att_homolog':
				$citation->proposer_homologation($id_utilisateur);
				break;
			case 'suppr_attv_ajout_invalide':
				$citation->invalider($id_utilisateur);
				break;
			case 'suppr_attv_invalide':
				$citation->revalider($id_utilisateur);
				break;
			case 'ajouter_commentaire':
				$citation->ajoute_commentaire('info', $id_utilisateur, htmlentities($_POST['texte'],ENT_COMPAT,'UTF-8'));
				break;
			default:
				throw new \Exception('param validation invalide');

		}

		if (!empty($_GET['supprimer_commentaire'])) {
			bobs_tests::cli($_GET['supprimer_commentaire'], bobs_tests::except_si_inf_1);
			$citation->supprime_commentaire($_GET['supprimer_commentaire']);
		}

		if (!empty($_GET['document_detacher'])) {
			$citation->document_detacher($_GET['document_detacher']);
		}

		$citation = new bobs_citation($this->db, $_GET['id']);
		$this->assign_by_ref('citation', $citation);
		$this->assign('ages', bobs_citation::get_age_list());
		$this->assign('genres', bobs_citation::get_gender_list());
	}

	protected function before_observation_edit() {
		$id_utilisateur = $_SESSION[SESS]['id_utilisateur'];
		if (isset($_POST['champ']))
		switch($_POST['champ']) {
			case 'date_observation':
				$observation = get_observation($this->db, $_GET['id']);
				$observation->modification($id_utilisateur, 'date_observation', $_POST['valeur']);
				break;
			case 'heure_observation':
				$observation = get_observation($this->db, $_GET['id']);
				$vals = array('h'=>$_POST['h'], 'm'=>$_POST['m'], 's' => $_POST['s']);
				$observation->modification($id_utilisateur, 'heure_observation', $vals);
				break;
			case 'ajoute_observateur':
				$observation = get_observation($this->db, $_GET['id']);
				$observation->modification($id_utilisateur, 'ajoute_observateur', $_POST['valeur']);
				break;
			case 'retire_observateur':
				$observation = get_observation($this->db, $_GET['id']);
				$observation->modification($id_utilisateur, 'retire_observateur', $_POST['valeur']);
				break;
			default:
				if (!empty($_POST['champ']))
					throw new \Exception('modification non gérée');
		}
		$observation = get_observation($this->db, $_GET['id']);
		$this->assign_by_ref('observation', $observation);
	}

	protected function before_insertion_point() {
	    $data = array(
			'id_utilisateur' => $_SESSION[SESS]['id_utilisateur'],
			'reference' => '',
			'nom' => $_GET['nom'],
			'x' => $_GET['x'],
			'y' => $_GET['y']
	    );
	    $id_espace = bobs_espace_point::insert($this->db, $data);
	    echo $id_espace;
	    exit();
	}

	protected function before_commentaires() {
		$n = 400;
		$ctrs = bobs_commentaire::get_tous_les_commentaires($this->db, 400);
		$this->assign_by_ref('commentaires', $ctrs);
		$this->assign('n', $n);
	}

	protected function before_preinscription() {
		if (isset($_GET['s'])) {
			$o = unserialize(file_get_contents(BOBS_PREINSCRIPTION_PATH.'/'.$_GET['s']));
			$o->suivi = basename($_GET['s']);
			$o->annuler();
		}
		$pre = bobs_utilisateur_preinscription::liste();
		$derniers = bobs_utilisateur::derniers_comptes($this->db);
		$this->assign_by_ref('preinscriptions', $pre);
		$this->assign_by_ref('derniers', $derniers);
	}

	protected function before_tag_citations_autocomplete() {
		bobs_element::cls($_GET['term']);
		$t = bobs_tags::recherche_tag_citation($this->db, $_GET['term']);
		$tt = array();
		if (is_array($t))
			foreach ($t as $tag)
				if (!$tag->categorie_simple)
					$tt[] = array(
						'label' => $tag->lib,
						'id' => $tag->id_tag,
						'levenshtein' => levenshtein($_GET['term'], $tag->lib)
					);
		function mysort($a,$b) {
			if ($a['levenshtein'] == $b['levenshtein'])
				return 0;
			return $a['levenshtein']>$b['levenshtein']?1:-1;
		}
		usort($tt, 'mysort');
		echo json_encode($tt);
		exit();
	}

	protected function before_chiros() {
		if (isset($_GET['a'])) {
			switch ($_GET['a']) {
				case 'deplacer':
					$gite_a = new bobs_espace_chiro($this->db, $_GET['gite_a']);
					$gite_b = new bobs_espace_chiro($this->db, $_GET['gite_b']);
					$gite_a->deplacer_observations($gite_b);
					if (isset($_GET['suppr'])) {
						$gite_a->supprimer();
					}
					break;
				case 'supprimer':
					if (preg_match("/^P_.*/", $_GET['cavite'])) {
						$cavite = bobs_espace_chiro::get_by_ref($this->db, $_GET['cavite']);
						if ($cavite) {
							try {
								$cavite->supprimer();
								$this->ajoute_alerte('info', "Gîte supprimé");
							} catch (\Exception $e) {
								$this->ajoute_alerte('error', $e->getMessage());
							}
						} else {
							$this->ajoute_alerte('error', "Pas trouvé de gîte avec cet identifiant");
						}
					} else {
						$this->ajoute_alerte('error', "Seul les gîtes avec un identifiant commenceant par P peuvent être supprimée");
					}
					break;
				case 'raz_prospect':
					$tag = bobs_tags::by_ref($this->db, bobs_espace_chiro::tag_prospection);
					if (!empty($_GET['confirm'])) {
						$espaces = bobs_espace_chiro::get_list_a_prospecter($this->db, true);
						foreach ($espaces as $e) {
							$e['obj']->supprime_tag($tag->id_tag);
						}
					}
					break;
			}
		}
		$ca = $cb = false;
		if (isset($_GET['cavite_a']) && isset($_GET['cavite_b'])) {
			$ca = bobs_espace_chiro::get_by_ref($this->db, self::cls($_GET['cavite_a']));
			$cb = bobs_espace_chiro::get_by_ref($this->db, self::cls($_GET['cavite_b']));
		}
		if (isset($_GET['cavite'])) {
			$c = bobs_espace_chiro::get_by_ref($this->db, self::cls($_GET['cavite']));
		}
		$this->assign_by_ref('ca', $ca);
		$this->assign_by_ref('cb', $cb);
		$this->assign_by_ref('c', $c);

	}

	protected function before_structures() {
		$id_utilisateur = $_SESSION[SESS]['id_utilisateur'];
		$structure = false;
		if (isset($_GET['id_structure'])) {
			$structure = get_structure($this->db, $_GET['id_structure']);
		}
		if (isset($_POST['action'])) {
			switch ($_POST['action']) {
				case 'ajouter_structure':
					clicnat_structure::nouvelle($this->db, $_POST['nom']);
					break;
				case 'type_mad':
					$structure->update_field('type_mad', $_POST['type_mad']);
					break;
				case 'maj_ref_espace_structure':
					$data = $structure->__get("data");
					$data['ref_espace_structure'] = $_POST['ref_espace_structure'];
					$structure->update_field('data', json_encode($data));
					break;
				case 'maj_liste_classes':
					$data = $structure->__get("data");
					$data['classes'] = $_POST['classes'];
					$structure->update_field('data', json_encode($data));
					break;
				case 'ajoute_commune':
					$data = $structure->__get("data");
					if (!isset($data['communes'])) {
						$data['communes'] = array();
					}
					$data['communes'][] = $_POST['id_espace_commune'];
					$structure->update_field('data', json_encode($data));
					break;
				case 'retire_commune':
					$data = $structure->__get("data");
					if (isset($data['communes'])) {
						if (in_array($_POST['id_espace_commune'], $data['communes'])) {
							echo "b";
							$t = $data['communes'];
							$data['communes'] = array();
							foreach ($t as $id) {
								echo "c";
								if ($id != $_POST['id_espace_commune'])
									$data['communes'][] = $id;
							}
						}
					}
					$structure->update_field('data', json_encode($data));
					break;
				case 'maj_xml':
					$data = $structure->__get("data");
					$data['xml'] = $_POST['xml'];
					$structure->update_field('data', json_encode($data));
					break;
				case 'ajoute_membre':
					$utilisateur = get_utilisateur($this->db, $_POST['id_utilisateur']);
					$structure->ajoute_membre($_POST['id_utilisateur']);
					$this->ajoute_alerte('info', "Utilisateur $utilisateur ajouté comme membre");
					$this->redirect("?t=structures&id_structure={$structure->id_structure}");
					break;
				case 'ajoute_diffusion_restreinte':
					$utilisateur = get_utilisateur($this->db, $_POST['id_utilisateur']);
					$structure->ajoute_diffusion_restreinte($_POST['id_utilisateur']);
					$this->ajoute_alerte('info', "Utilisateur $utilisateur ajouté aux diffusions restreintes");
					$this->redirect("?t=structures&id_structure={$structure->id_structure}");
					break;
				case 'retirer_membre':
					$utilisateur = get_utilisateur($this->db, $_POST['id_utilisateur']);
					$structure->supprime_membre($_POST['id_utilisateur']);
					$this->ajoute_alerte('info', "Utilisateur $utilisateur retiré de la liste des membres");
					$this->redirect("?t=structures&id_structure={$structure->id_structure}");
					break;
				case 'retirer_diffusion_restreinte':
					$utilisateur = get_utilisateur($this->db, $_POST['id_utilisateur']);
					$structure->supprime_diffusion_restreinte($_POST['id_utilisateur']);
					$this->ajoute_alerte('info', "Utilisateur $utilisateur retiré des diffusions restreintes");
					$this->redirect("?t=structures&id_structure={$structure->id_structure}");
					break;
				case 'identifiant_txt_id':
					$structure->update_field('txt_id', $_POST['txt_id']);
					$this->ajoute_alerte('info', 'Identifiant structure modifié');
					$this->redirect("?t=structures&id_structure={$structure->id_structure}");
					break;
			}
		}
		$this->assign_by_ref('structures', clicnat_structure::structures($this->db));
		$this->assign_by_ref('structure', $structure);
		$classes = array();
		foreach (bobs_classe::get_classes() as $c) {
			$classes[$c] = bobs_classe::get_classe_lib_par_lettre($c);
		}
		$this->assign_by_ref('classes', $classes);
		$apercu_possible = true;
		try {
			if ($structure)
				$structure->get_extractions();
			else
				$apercu_possible = false;
		} catch (\Exception $e) {
			$apercu_possible = false;
		}
		$this->assign('apercu_possible', $apercu_possible);
	}

	public function run() {
		global $start_time;
		if ($this->session() || $this->template() == 'accueil') {
			$before_func = 'before_'.$this->template();
			if (method_exists($this, $before_func))
				$this->$before_func();

			$this->assign('sel', $this->selection_utilisateur_get()?true:false);
			if ($this->selection_utilisateur_get()) {
				$this->assign('nomsel', $this->selection_utilisateur_get(true));
				$this->assign('idsel', $this->selection_utilisateur_get());
				$usel = new bobs_utilisateur($this->db, $this->selection_utilisateur_get());
				$usel->associations_get_objs();
				$this->assign('usel', $usel);
			}
			$this->assign('menu_classes', $this->classes_especes());
			$this->assign('tps_exec_avant_display', sprintf("%0.4f", microtime(true) - $start_time));
			parent::display($this->template(true).'.tpl');
		} else {
			$this->redirect('?t=accueil&msg=reco');
		}
	}
}

require_once(DB_INC_PHP);
get_db($db);
$qg = new Qg($db);
$qg->run();
?>
