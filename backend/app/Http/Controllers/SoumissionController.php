<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Soumission;
use App\Models\DocumentSoumission;
use Illuminate\Support\Str;
use App\Models\Lot;
use Illuminate\Support\Facades\Mail;
class SoumissionController extends Controller
{
    /**
     * Pour l'admin : récupère toutes les soumissions dont l'offre est destinée au secteur de l'admin.
     */
    public function index()
    {
        $user = auth()->user();
        $secteurId = $user->secteur_id; 

        return Soumission::with(['user.entreprise', 'offre','offre.documents'])
            ->whereHas('offre', function($query) use ($secteurId) {
                $query->where('secteur_id', $secteurId); 
            })->get();
    }

    /**
     * Pour le soumissionnaire : récupère toutes les soumissions créées par l'utilisateur connecté.
     */
    public function store(Request $request)
    {
        $user = Auth::user();
        if (!$user) {
            return response()->json(['error' => 'Unauthenticated'], 401);
        }

        $validatedData = $request->validate([
            'offre_id' => 'required|exists:offres,id',
            'proposition' => 'nullable|string',
        ]);
   $soumission = Soumission::create([
            'user_id' => $user->id,
            'offre_id' => $validatedData['offre_id'],
            'proposition' => $validatedData['proposition'] ?? null,
        ]);

        if ($request->hasFile('documents')) {
            foreach ($request->file('documents') as $file) {
                $filename = time() . '_' . Str::random(8) . '_' . $file->getClientOriginalName();
                $filePath = $file->storeAs('soumissions', $filename, 'public');
                DocumentSoumission::create([
                    'soumission_id' => $soumission->id,
                    'nom_fichier' => $file->getClientOriginalName(),
                    'chemin_fichier' => $filePath,
                ]);
            }
        }

        return response()->json(['message' => 'Soumission created successfully!', 'soumission' => $soumission], 201);
    }
    
    /**
     * Pour l'admin : affiche une soumission spécifique seulement si l'offre est destinée à l'entreprise de l'admin.
     */
    public function show($id)
    {
        $user = auth()->user();
    
        $soumission = Soumission::with(['user.entreprise', 'offre.secteur', 'documents', 'offre.lots'])
            ->findOrFail($id);
    
        if ($soumission->offre->secteur_id !== $user->secteur_id) {
            return response()->json(['error' => 'Accès non autorisé'], 403);
        }

    
        $lots = $soumission->offre->lots;

        return response()->json([
            'soumission' => $soumission,
            'lots' => $lots
        ]);
    }
    
    /**
     * Pour le soumissionnaire : récupère les soumissions créées par l'utilisateur connecté.
     */
    public function getUserSoumission()
    {
        $user = auth()->user();
        return Soumission::with(['documents', 'offre.secteur'])
        ->where('user_id', $user->id)
        ->get();

    
        if ($soumissions->isEmpty()) {
            return response()->json(['message' => 'Aucune soumission trouvée'], 404);
        }
    
        return $soumissions;
    }
    
    /**
     * Mise à jour d'une soumission par l'administrateur.
     */
  
    
    public function update(Request $request, $id)
    {
        $request->validate([
            'statut'            => 'required|in:Acceptée,Rejetée',
            'commentaire_admin' => 'nullable|string',
            'lots'              => 'nullable|array',
            'lots.*'            => 'exists:lots,id',
        ]);
    
        $soumission = Soumission::with('offre')->findOrFail($id); // Charger explicitement l'offre

        $titre = $soumission->offre ? $soumission->offre->titre_offre : 'offre inconnue';
        $oldStatut = $soumission->statut;
        $oldCommentaire = $soumission->commentaire_admin;
    
        $soumission->update([
            'statut' => $request->input('statut'),
            'commentaire_admin' => $request->input('commentaire_admin'),
        ]);
   
        \DB::table('historique_soumissions')->insert([
            'soumission_id' => $soumission->id,
            'ancien_statut' => $oldStatut,
            'nouveau_statut' => $request->input('statut'),
            'ancien_commentaire' => $oldCommentaire,
            'nouveau_commentaire' => $request->input('commentaire_admin'),
            'admin_id' => auth()->user()->id,
            'date_modification' => now(),
        ]);
    
        if ($request->has('lots')) {
            foreach ($request->input('lots') as $lotId) {
                $lot = Lot::findOrFail($lotId);
                $lot->statut = $request->input('statut') === 'Acceptée' ? 'Attribué' : 'En cours';
                $lot->save();
            }
        }
    
        if ($request->input('statut') === 'Acceptée') {
            $offre = $soumission->offre;
            if ($offre) {
                $offre->update(['etat_offre' => 'Attribué']);
            }
        }
        if (!$soumission->offre || !$soumission->offre->titre_offre) {
            \Log::warning("Offre introuvable ou titre manquant pour la soumission ID: " . $soumission->id);
        }
       
        Mail::raw(
            "Votre soumission pour l'offre '" . $soumission->offre->titre_offre . "' a été " . strtolower($soumission->statut) . ". ❗", 
            function ($message) use ($soumission) {
                $message->to($soumission->user->email)
                        ->subject('Mise à jour de votre soumission');
            }
        );

        $message = "Votre soumission pour l'offre '" . $titre . "' a été " . strtolower($soumission->statut);

        if ($soumission->offre && $soumission->offre->titre) {
            $titre = $soumission->offre->titre;
        } else {
            $titre = 'offre inconnue'; 
        }
       
        if (strlen($message) > 255) {
            $message = substr($message, 0, 252) . '...';
        }

       
        \DB::table('notifications_custom')->insert([
            'user_id' => $soumission->user->id,
            'message' => $message,
            'is_read' => false,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    
        return response()->json(['message' => 'Soumission mise à jour'], 200);
    }
    
}
