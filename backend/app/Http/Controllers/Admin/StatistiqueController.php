<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Offre;
use App\Models\Soumission;
use App\Models\Admin;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
use DB;

class StatistiqueController extends Controller
{
    /**
     * Get general statistics for the dashboard.
     */
    public function getStats()
    {
        $user = Auth::user();
        $isSuperAdmin = $user->role === 'superadmin'; // Adapte le nom de ton champ si besoin
        $secteurId = $user->secteur_id;
    
        $baseQuery = Offre::query();
        if (!$isSuperAdmin) {
            $baseQuery->where('secteur_id', $secteurId);
        }
    
        // Appels d'offre
        $totalAppelsOffre = (clone $baseQuery)->where('type_offre', 'Appel d\'offre')->count();
        $totalAppelsOffreFR = (clone $baseQuery)->where('type_offre', 'Appel d\'offre')->where('langue', 'Français')->count();
        $totalAppelsOffreAR = (clone $baseQuery)->where('type_offre', 'Appel d\'offre')->where('langue', 'Arabe')->count();
    
        // Avis de consultation
        $totalAvisConsultation = (clone $baseQuery)->where('type_offre', 'Avis de consultation')->count();
        $totalAvisConsultationFR = (clone $baseQuery)->where('type_offre', 'Avis de consultation')->where('langue', 'Français')->count();
        $totalAvisConsultationAR = (clone $baseQuery)->where('type_offre', 'Avis de consultation')->where('langue', 'Arabe')->count();
    
        // Avis de manifestation
        $totalAvisManifestation = (clone $baseQuery)->where('type_offre', 'Avis de manifestation')->count();
        $totalAvisManifestationFR = (clone $baseQuery)->where('type_offre', 'Avis de manifestation')->where('langue', 'Français')->count();
        $totalAvisManifestationAR = (clone $baseQuery)->where('type_offre', 'Avis de manifestation')->where('langue', 'Arabe')->count();
    
        $today = \Carbon\Carbon::today();
    
    
        $newAppelsOffre = (clone $baseQuery)->where('type_offre', 'Appel d\'offre')->where('created_at', '>=', $today)->count();
        $newAvisConsultation = (clone $baseQuery)->where('type_offre', 'Avis de consultation')->where('created_at', '>=', $today)->count();
        $newAvisManifestation = (clone $baseQuery)->where('type_offre', 'Avis de manifestation')->where('created_at', '>=', $today)->count();
    
        return response()->json([
            'totalAppelsOffre'         => $totalAppelsOffre,
            'totalAppelsOffreFR'       => $totalAppelsOffreFR,
            'totalAppelsOffreAR'       => $totalAppelsOffreAR,
            'newAppelsOffre'           => $newAppelsOffre,
    
            'totalAvisConsultation'    => $totalAvisConsultation,
            'totalAvisConsultationFR'  => $totalAvisConsultationFR,
            'totalAvisConsultationAR'  => $totalAvisConsultationAR,
            'newAvisConsultation'      => $newAvisConsultation,
    
            'totalAvisManifestation'   => $totalAvisManifestation,
            'totalAvisManifestationFR' => $totalAvisManifestationFR,
            'totalAvisManifestationAR' => $totalAvisManifestationAR,
            'newAvisManifestation'     => $newAvisManifestation,
        ]);
    }
    

  
    //pie chart
   

public function getDetailedOfferStats()
{
    $user = Auth::user();
    $isSuperAdmin = $user->role === 'superadmin';
    $secteurId = $user->secteur_id;

    $types = [
        'Appel d\'offre',
        'Avis de consultation',
        'Avis de manifestation'
    ];

    $etats = [
        'Attribué',
        'En Cours',
        'Infructueux',
        'Annulé'
    ];

    $detailedStats = [];

    foreach ($types as $type) {
       
        $statsPerEtat = array_fill_keys($etats, 0);

        $query = Offre::where('type_offre', $type)
                      ->select('etat_offre', DB::raw('count(*) as total'))
                      ->groupBy('etat_offre');

        if (!$isSuperAdmin) {
            $query->where('secteur_id', $secteurId);
        }

        $results = $query->get();

        foreach ($results as $result) {
            $etat = $result->etat_offre;
            if (isset($statsPerEtat[$etat])) {
                $statsPerEtat[$etat] = $result->total;
            }
        }

        $detailedStats[$type] = $statsPerEtat;
    }

    return response()->json($detailedStats);
}

  
 //(total offers, total users, offers with lots)

public function getDashboardInfos()
{
    $user = Auth::user();
    $isSuperAdmin = $user->role === 'superadmin'; 
    $secteurId = $user->secteur_id;

    if ($isSuperAdmin) {
        // Super Admin - all companies
        $totalOffers = Offre::count();
        $totalUsers = User::count();
        $totalOffersWithLot = Offre::whereHas('lots')->count();
    } else {
        // Admin - only their secteur
        $totalOffers = Offre::where('secteur_id', $secteurId)->count();
        $totalUsers = Admin::where('secteur_id', $secteurId)->count();
        $totalOffersWithLot = Offre::where('secteur_id', $secteurId)
                                   ->whereHas('lots')
                                   ->count();
    }

    return response()->json([
        'totalOffers'        => $totalOffers,
        'totalUsers'         => $totalUsers,
        'totalOffersWithLot' => $totalOffersWithLot,
    ]);
}
//line chart
  public function getOfferTrendStats(Request $request)
{
    $scale = $request->input('scale', 'Mois');
    $user = Auth::user();
    $isSuperAdmin = $user->role === 'superadmin';
    $secteurId = $user->secteur_id;

    $types = [
        'Appel d\'offre',
        'Avis de consultation',
        'Avis de manifestation'
    ];

    $trendStats = [];

    switch ($scale) {
        case 'Jour':
            $groupExpression = DB::raw("DATE(date_publication) as period");
            break;
        case 'Année':
            $groupExpression = DB::raw("YEAR(date_publication) as period");
            break;
        case 'Mois':
            $groupExpression = DB::raw("DATE_FORMAT(date_publication, '%Y-%m') as period");
            break;
        case 'Semaine':
            foreach ($types as $type) {
                $startOfWeek = \Carbon\Carbon::now()->startOfWeek(); 
                $endOfWeek = \Carbon\Carbon::now()->endOfWeek();

                $query = Offre::where('type_offre', $type)
                    ->whereBetween('date_publication', [$startOfWeek, $endOfWeek]);

                if (!$isSuperAdmin) {
                    $query->where('secteur_id', $secteurId);
                }

                $results = $query->select(
                        DB::raw('DAYOFWEEK(date_publication) as day'),
                        DB::raw('COUNT(*) as total')
                    )
                    ->groupBy('day')
                    ->get();

                $dayMapping = [
                    1 => 'Dim',
                    2 => 'Lun',
                    3 => 'Mar',
                    4 => 'Mer',
                    5 => 'Jeu',
                    6 => 'Ven',
                    7 => 'Sam',
                ];

                $weeklyData = [];
                foreach ($dayMapping as $i => $dayName) {
                    $weeklyData[$dayName] = 0;
                }

                foreach ($results as $row) {
                    $dayName = $dayMapping[$row->day];
                    $weeklyData[$dayName] = $row->total;
                }

                $trendStats[$type] = $weeklyData;
            }

            return response()->json($trendStats);
    }

    foreach ($types as $type) {
        $query = Offre::where('type_offre', $type);

        if (!$isSuperAdmin) {
            $query->where('secteur_id', $secteurId);
        }

        $results = $query->select($groupExpression, DB::raw('count(*) as total'))
            ->groupBy('period')
            ->orderBy('period')
            ->get();

        $trendStats[$type] = $results;
    }

    return response()->json($trendStats);
}


 /**
 statistique admin

 */
public function getUserOfferStats()
{
    $user = Auth::user();
    $isSuperAdmin = ($user->role === 'superadmin');
    $secteurId = $user->secteur_id;

    $query = DB::table('admins')
        ->leftJoin('offres', 'offres.admin_id', '=', 'admins.id')
        ->select(
            'admins.id as admin_id',
            'admins.nom',
            'admins.prenom',
            'admins.telephone',
            'admins.email',
            'offres.type_offre',
            DB::raw('COUNT(offres.id) as count')
        )
        ->groupBy(
            'admins.id',
            'admins.nom',
            'admins.prenom',
            'admins.telephone',
            'admins.email',
            'offres.type_offre'
        );

    if (!$isSuperAdmin) {
        $query->where('admins.secteur_id', $secteurId);
    }

    $data = $query->get();

    $result = [];

    foreach ($data as $row) {
        if (!isset($result[$row->admin_id])) {
            $result[$row->admin_id] = [
                'admin_id'      => $row->admin_id,
                'nom'           => $row->nom,
                'prenom'        => $row->prenom,
                'telephone'     => $row->telephone,
                'email'         => $row->email,
                'total_offres'  => 0,
                'types'         => []
            ];
        }

        if ($row->type_offre) {
            $result[$row->admin_id]['types'][$row->type_offre] = $row->count;
            $result[$row->admin_id]['total_offres'] += $row->count;
        }
    }

  
    usort($result, function ($a, $b) {
        return $b['total_offres'] <=> $a['total_offres'];
    });

    return response()->json(array_values($result));
}

  
    public function getSoumissionStats()
    {
        $user = Auth::user();
        $secteurId = $user->secteur_id;

        $soumissionsParOffre = DB::table('soumissions')
            ->join('offres', 'soumissions.offre_id', '=', 'offres.id')
            ->where('offres.secteur_id', $secteurId)
            ->select(
                'offres.id as offre_id',
                'offres.titre_offre',
                DB::raw('count(soumissions.id) as total_soumissions')
            )
            ->groupBy('offres.id', 'offres.titre_offre')
            ->get();

        $totalSoumissions = DB::table('soumissions')
            ->join('offres', 'soumissions.offre_id', '=', 'offres.id')
            ->where('offres.secteur_id', $secteurId)
            ->count();

        return response()->json([
            'soumissionsParOffre' => $soumissionsParOffre,
            'totalSoumissions' => $totalSoumissions,
        ]);
    }

   
    public function getTotalOffers()
    {
        $user = Auth::user();
        $secteurId = $user->secteur_id;

        $totalOffers = Offre::where('secteur_id', $secteurId)->count();
        return response()->json(['totalOffers' => $totalOffers]);
    }

// map
public function getOffersByTypeAndWilaya()
{
    $user = Auth::user();
    $isSuperAdmin = $user->role === 'superadmin';
    $secteurId = $user->secteur_id;

    $types = [
        'Appel d\'offre',
        'Avis de consultation',
        'Avis de manifestation'
    ];

    // Liste des noms des 58 wilayas
    $wilayas = [
        "Adrar", "Chlef", "Laghouat", "Oum El Bouaghi", "Batna", "Bejaia", "Biskra", "Béchar", "Blida", "Bouira",
        "Tamanrasset", "Tébessa", "Tlemcen", "Tiaret", "Tizi Ouzou", "Alger", "Djelfa", "Jijel", "Sétif", "Saïda",
        "Skikda", "Sidi Bel Abbès", "Annaba", "Guelma", "Constantine", "Médéa", "Mostaganem", "M'Sila", "Mascara", "Ouargla",
        "Oran", "El Bayadh", "Illizi", "Bordj Bou Arréridj", "Boumerdès", "El Tarf", "Tindouf", "Tissemsilt", "El Oued", "Khenchela",
        "Souk Ahras", "Tipaza", "Mila", "Aïn Defla", "Naâma", "Aïn Témouchent", "Ghardaïa", "Relizane", "Timimoun", "Bordj Badji Mokhtar",
        "Ouled Djellal", "Béni Abbès", "In Salah", "In Guezzam", "Touggourt", "Djanet", "El M'Ghair", "El Menia"
    ];

    $offersByWilaya = [];

    foreach ($wilayas as $wilayaName) {
        foreach ($types as $type) {
            $offersByWilaya[$wilayaName][$type] = 0;
        }
    }

    $query = Offre::select('wilaya', 'type_offre', DB::raw('count(*) as total'))
                  ->whereIn('type_offre', $types);

    if (!$isSuperAdmin) {
        $query->where('secteur_id', $secteurId);
    }

    $results = $query->groupBy('wilaya', 'type_offre')->get();

    foreach ($results as $row) {
        $wilaya = $row->wilaya; 
        $type = $row->type_offre;
        $offersByWilaya[$wilaya][$type] = $row->total;
    }

    return response()->json($offersByWilaya);
}


public function getTopSoumissionsByOffre()
{
    $user = Auth::user();
    $isSuperAdmin = $user->role === 'superadmin';
    $secteurId = $user->secteur_id;

    $soumissionsParOffre = DB::table('soumissions')
        ->join('offres', 'soumissions.offre_id', '=', 'offres.id')
        ->when(!$isSuperAdmin, function ($query) use ($secteurId) {
            return $query->where('offres.secteur_id', $secteurId);
        })
        ->select(
            'offres.id as offre_id',
            'offres.titre_offre',
            DB::raw('COUNT(soumissions.id) as total_soumissions')
        )
        ->groupBy('offres.id', 'offres.titre_offre')
        ->orderByDesc('total_soumissions')
        ->limit(10)
        ->get();

    return response()->json($soumissionsParOffre);
}
}
