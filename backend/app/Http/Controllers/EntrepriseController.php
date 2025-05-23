<?php

namespace App\Http\Controllers;

use App\Models\Entreprise;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class EntrepriseController extends Controller
{
    /**
     * Affiche la liste des entreprises.
     */
    public function index()
    {
        return response()->json(Entreprise::all());
    }

    /**
     * Stocke une nouvelle entreprise.
     */
    public function store(Request $request)
    {
        // Validation des données
        $validatedData = $request->validate([
            'nom_entreprise'   => 'required|string|max:255',
            'activite'         => 'required|string|max:255',
            'categorie'        => 'required|string|max:255',
            'pays'             => 'required|string|max:255',
            'wilaya'           => [Rule::requiredIf($request->pays == 'Algérie'), 'nullable', 'string', 'max:255'],
            'adresse'          => 'required|string|max:255',
            'code_commerce'    => 'required|string|unique:entreprises',
            'num_fiscal'       => 'required|string|unique:entreprises',
            'num_statistique'  => 'required|string|unique:entreprises',
            'num_national'     => 'required|string|unique:entreprises',
            'nombre_employes'  => 'required|string|max:255',
            'logo'             => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        \DB::beginTransaction();
        try {
          
            $entrepriseData = $validatedData;
            $entrepriseData['logo'] = 'storage/logo/default.png';

     
            $entreprise = Entreprise::create($entrepriseData);

         
            if ($request->hasFile('logo')) {
                $logoPath = $request->file('logo')->store('logo', 'public');
                $logoPath = 'storage/' . $logoPath;
            } else {
                $logoPath = 'storage/logo/default.png';
            }
            $entreprise->update(['logo' => $logoPath]);

            \DB::commit();

            return response()->json($entreprise, 201);
        } catch (\Exception $e) {
            \DB::rollback();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Met à jour une entreprise existante.
     */
    public function update(Request $request, $id)
    {
        $entreprise = Entreprise::findOrFail($id);

        $validatedData = $request->validate([
            'nom_entreprise'   => 'sometimes|required|string|max:255',
            'activite'         => 'sometimes|required|string|max:255',
            'categorie'        => 'sometimes|required|string|max:255',
            'pays'             => 'sometimes|required|string|max:255',
            'wilaya'           => 'sometimes|nullable|string|max:255',
            'adresse'          => 'sometimes|required|string|max:255',
            'code_commerce'    => 'sometimes|required|string|unique:entreprises,code_commerce,' . $entreprise->id,
            'num_fiscal'       => 'sometimes|required|string|unique:entreprises,num_fiscal,' . $entreprise->id,
            'num_statistique'  => 'sometimes|required|string|unique:entreprises,num_statistique,' . $entreprise->id,
            'num_national'     => 'sometimes|required|string|unique:entreprises,num_national,' . $entreprise->id,
            'nombre_employes'  => 'sometimes|required|string|max:255',
            'logo'             => 'sometimes|nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        \DB::beginTransaction();
        try {
            
            if ($request->hasFile('logo')) {
                $logoPath = $request->file('logo')->store('logo', 'public');
                $validatedData['logo'] = 'storage/' . $logoPath;
            }
            $entreprise->update($validatedData);

            \DB::commit();
            return response()->json($entreprise);
        } catch (\Exception $e) {
            \DB::rollback();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Supprime une entreprise.
     */
    public function destroy($id)
    {
        $entreprise = Entreprise::findOrFail($id);
        $entreprise->delete();

        return response()->json(['message' => 'Entreprise supprimée avec succès']);
    }
}
