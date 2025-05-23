<?php

namespace App\Http\Controllers;

use App\Models\Offre;
use App\Models\Lot;
use App\Models\Enterprise;
use App\Models\DocumentOffre;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;


class OffreController extends Controller
{
    /**
     * Liste des offres avec leur entreprise et leurs lots.
     */
    public function index()
    {
        $offers = Offre::with(['secteur', 'lots', 'documents'])->get();
        return response()->json($offers, 200);
    }

    /**
     * Création d'une nouvelle offre avec ses lots.
     */
    public function store(Request $request)
    {
        $admin = auth()->user();
        
        if (!$admin || !$admin->secteur_id) {
            return response()->json(['message' => "Vous n'êtes pas autorisé à créer une offre."], 403);
        }
    
        $request->validate([
            'langue'           => 'required|string',
            'etat_offre'       => 'required|string',
            'wilaya'           => 'required|string',
            'numero_offre'     => 'required|string|unique:offres,numero_offre',
            'titre_offre'      => 'required|string',
            'type_offre'       => 'required|string',
            'niveau'           => 'required|in:National,International',
            'date_publication' => 'required|date',
            'date_limite'      => 'required|date|after_or_equal:date_publication',
            'date_prorogation' => 'nullable|date|after_or_equal:date_limite',
            'description'      => 'required|string',
            'etat'             => 'required|string',
            'lots'             => 'nullable|array',
            'lots.*.numero_lot' => 'required_with:lots|string',
            'lots.*.description' => 'required_with:lots|string',
            'lots.*.document_lot' => 'nullable|file|mimes:pdf|max:4096',
            'lots.*.description_ar' => 'nullable|string',
            'titre_offre_ar'   => 'nullable|string',
            'description_ar'   => 'nullable|string',
        ]);
    
        $offre = Offre::create([
            'secteur_id'    => $admin->secteur_id, 
            'admin_id'         => $admin->id, 
            'langue'           => $request->langue,
            'etat_offre'       => $request->etat_offre,
            'wilaya'           => $request->wilaya,
            'numero_offre'     => $request->numero_offre,
            'titre_offre'      => $request->titre_offre,
            'type_offre'       => $request->type_offre,
            'niveau'           => $request->niveau,
            'date_publication' => $request->date_publication,
            'date_limite'      => $request->date_limite,
            'date_prorogation' => $request->date_prorogation,
            'description'      => $request->description,
            'etat'             => $request->etat,
            'titre_offre_ar'   => $request->titre_offre_ar,
            'description_ar'   => $request->description_ar,
        ]);
    
        if ($request->hasFile('document_pdf')) {
            DocumentOffre::create([
                'offre_id' => $offre->id,
                'document_pdf' => $request->file('document_pdf')->store('documents/pdf'),
            ]);
        }
        if ($request->hasFile('document_pdf_ar')) {
            DocumentOffre::create([
                'offre_id' => $offre->id,
                'document_pdf_ar' => $request->file('document_pdf_ar')->store('documents/pdf_ar'),
            ]);
        }
    
        if ($request->has('lots')) {
            foreach ($request->lots as $index => $lotData) {
                Lot::create([
                    'offre_id'     => $offre->id,
                    'numero_lot'   => $lotData['numero_lot'],
                    'description'  => $lotData['description'],
                    'description_ar' => $lotData['description_ar'] ?? null,
                    'a_des_lots'   => $request->a_des_lots ?? false,
                ]);
            }
        }
        if ($request->a_des_lots && $request->has('lots')) {
            foreach ($request->lots as $lot) {
                Lot::create([
                    'offre_id' => $offre->id,
                    'numero_lot' => $lot['numero_lot'],
                    'description' => $lot['description'],
                ]);
            }
        }
        return response()->json([
            'message' => "Offre créée avec succès",
            'data' => $offre->load('lots'),
        ], 201);
    }
    
    
    /**
     * Afficher une offre avec ses lots.
     */
    public function show($id)
    {
        $offre = Offre::with(['secteur', 'lots','documents'])->find($id);
        
        if (!$offre) {
            return response()->json(['message' => 'Offre non trouvée'], 404);
        }
        
        return response()->json($offre);
    }
     /**
     * Mettre à jour une offre et ses lots.
     */
public function update(Request $request, $id)
{
    $user = Auth::user();

    if ($user->role !== 'superadmin' && $user->secteur_id !== Offre::findOrFail($id)->secteur_id) {
        return response()->json(['message' => "Vous n'êtes pas autorisé à modifier cette offre."], 403);
    }

    \Log::debug("Update offre $id", $request->all());
    $offre = Offre::findOrFail($id);


    $validated = $request->validate([
        'langue'                => 'nullable|string|max:10',
        'etat_offre'            => 'nullable|string|max:50',
        'wilaya'                => 'nullable|string|max:100',
        'numero_offre'          => 'nullable|string|max:100|unique:offres,numero_offre,'.$id,
        'titre_offre'           => 'required|string|max:255',
        'titre_offre_ar'        => 'nullable|string|max:255',
        'type_offre'            => 'nullable|string|max:100',
        'niveau'                => 'nullable|string|max:100',
        'date_publication'      => 'nullable|date',
        'date_limite'           => 'nullable|date|after_or_equal:date_publication',
        'date_prorogation'      => 'nullable|date|after_or_equal:date_limite',
        'description'           => 'nullable|string',
        'description_ar'        => 'nullable|string',
        'etat'                  => 'nullable|string|max:50',
        // fichiers
        'document_pdf'          => 'nullable|file|mimes:pdf|max:2048',
        'document_pdf_ar'       => 'nullable|file|mimes:pdf|max:2048',
        'document_annulation'    => 'nullable|file|mimes:pdf|max:2048',
        'document_annulation_ar' => 'nullable|file|mimes:pdf|max:2048',
        'document_infructueux'   => 'nullable|file|mimes:pdf|max:2048',
        'document_infructueux_ar'=> 'nullable|file|mimes:pdf|max:2048',
        'document_prorogation'   => 'nullable|file|mimes:pdf|max:2048',
        'document_prorogation_ar'=> 'nullable|file|mimes:pdf|max:2048',
        'journal'               => 'nullable|file|mimes:pdf|max:2048',
        'journal_ar'            => 'nullable|file|mimes:pdf|max:2048',
        // lots
        'lots'                  => 'nullable|array',
        'lots.*.id'             => 'nullable|integer|exists:lots,id',
        'lots.*.numero_lot'     => 'required|string|max:100',
        'lots.*.description'    => 'required|string',
        'lots.*.description_ar' => 'nullable|string',
        'lotsToDelete'          => 'nullable|array',
        'lotsToDelete.*'        => 'integer|exists:lots,id',
    ]);

    $offre->fill([
    
        'admin_id'        => $user->id,
        'langue'          => $validated['langue']          ?? $offre->langue,
        'etat_offre'      => $validated['etat_offre']      ?? $offre->etat_offre,
        'wilaya'          => $validated['wilaya']          ?? $offre->wilaya,
        'numero_offre'    => $validated['numero_offre']    ?? $offre->numero_offre,
        'titre_offre'     => $validated['titre_offre'],
        'titre_offre_ar'  => $validated['titre_offre_ar']  ?? $offre->titre_offre_ar,
        'type_offre'      => $validated['type_offre']      ?? $offre->type_offre,
        'niveau'          => $validated['niveau']          ?? $offre->niveau,
        'date_publication'=> $validated['date_publication']?? $offre->date_publication,
        'date_limite'     => $validated['date_limite']     ?? $offre->date_limite,
        'date_prorogation'=> $validated['date_prorogation']?? $offre->date_prorogation,
        'description'     => $validated['description']     ?? $offre->description,
        'description_ar'  => $validated['description_ar']  ?? $offre->description_ar,
        'etat'            => $validated['etat']            ?? $offre->etat,
    ]);
  if ($user->role !== 'superadmin') {
        $data['secteur_id'] = $user->secteur_id;
    }
  
   if ($request->hasFile('document_pdf')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->document_pdf = $request->file('document_pdf')->store('documents/pdf');
    $document->save();
}
if ($request->hasFile('document_pdf_ar')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->document_pdf_ar = $request->file('document_pdf_ar')->store('documents/pdf_ar');
    $document->save();
}
if ($request->hasFile('document_annulation')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->document_annulation = $request->file('document_annulation')->store('documents/annulations');
    $document->save();
}
if ($request->hasFile('document_annulation_ar')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->document_annulation_ar = $request->file('document_annulation_ar')->store('documents/annulations_ar');
    $document->save();
}
if ($request->hasFile('document_infructueux')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->document_infructueux = $request->file('document_infructueux')->store('documents/infructueux');
    $document->save();
}
if ($request->hasFile('document_infructueux_ar')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->document_infructueux_ar = $request->file('document_infructueux_ar')->store('documents/infructueux_ar');
    $document->save();
}
if ($request->hasFile('document_prorogation')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->document_prorogation = $request->file('document_prorogation')->store('documents/prorogations');
    $document->save();
}
if ($request->hasFile('document_prorogation_ar')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->document_prorogation_ar = $request->file('document_prorogation_ar')->store('documents/prorogations_ar');
    $document->save();
}
if ($request->hasFile('journal')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->journal = $request->file('journal')->store('documents/journaux');
    $document->save();
}
if ($request->hasFile('journal_ar')) {
    $document = DocumentOffre::firstOrNew(['offre_id' => $offre->id]);
    $document->journal_ar = $request->file('journal_ar')->store('documents/journaux_ar');
    $document->save();
}

    //  Gestion des lots
    $existingIds = $offre->lots->pluck('id')->all();
    $updatedIds  = [];

    foreach ($request->input('lots', []) as $lotData) {
        if (!empty($lotData['id'])) {
            // update
            $lot = Lot::find($lotData['id']);
            $lot->update([
                'numero_lot'     => $lotData['numero_lot'],
                'description'    => $lotData['description'],
                'description_ar' => $lotData['description_ar'] ?? $lot->description_ar,
            ]);
            $updatedIds[] = $lot->id;
        } else {
            // create
            $new = Lot::create([
                'offre_id'       => $offre->id,
                'numero_lot'     => $lotData['numero_lot'],
                'description'    => $lotData['description'],
                'description_ar' => $lotData['description_ar'] ?? null,
            ]);
            $updatedIds[] = $new->id;
        }
    }
    
    $toDelete = array_diff(
        array_merge($existingIds, $request->input('lotsToDelete', [])),
        $updatedIds
    );
    if (!empty($toDelete)) {
        Lot::destroy($toDelete);
    }

    $offre->save();

    return response()->json([
        'message' => 'Offre mise à jour avec succès',
        'offre'   => $offre
    ], 200);
}

    /**
     * Supprimer une offre et ses lots.
     */
    public function destroy(Offre $offre)
    {
        $user = Auth::user();

        if ($user->role !== 'superadmin' && $user->secteur_id !== $offre->secteur_id) {
            return response()->json(['message' => "Vous n'êtes pas autorisé à supprimer cette offre."], 403);
        }

        foreach ($offre->lots as $lot) {
            if ($lot->document_lot) {
                Storage::delete($lot->document_lot);
            }
            $lot->delete();
        }

        if ($offre->document_pdf) {
            Storage::delete($offre->document_pdf);
        }

        $offre->delete();

        return response()->json(['message' => "Offre supprimée avec succès"], 200);
    }

    /**
     * Récupérer les publications avec leurs lots et secteur.
     */
    public function getPublications()
    {
        $user = Auth::user();

        if ($user->role === 'superadmin') {
            $publications = Offre::with(['secteur', 'lots', 'documents'])->get();
        } elseif ($user->role === 'admin') {
            $publications = Offre::with(['secteur', 'lots', 'documents'])
                ->where('secteur_id', $user->secteur_id)
                ->get();
        } else {
            $publications = collect();
        }

        return response()->json([
            'role' => $user->role,
            'publications' => $publications
        ], 200);
    }
    /**
     * Récupérer les offres d'une entreprise pour un search
     
     */
public function search(Request $request)
{
    $request->validate([
        'search' => 'nullable|string|min:2|max:100'
    ]);

    $q = $request->input('search');
    if (!$q) {
        return response()->json(['offres' => []]);
    }

    $offres = Offre::where(function($qb) use ($q) {
            $qb->where('titre_offre', 'LIKE', "%{$q}%")
               ->orWhere('description', 'LIKE', "%{$q}%");
        })
        ->orderBy('titre_offre', 'asc')
        ->limit(10)
        ->get([
            'id',
            'titre_offre as title',   
            'description'
        ]);

    return response()->json(['offres' => $offres]);
}

}
