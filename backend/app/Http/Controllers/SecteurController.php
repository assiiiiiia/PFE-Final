<?php
namespace App\Http\Controllers;
use App\Models\Secteur;
use Illuminate\Http\Request;

class SecteurController extends Controller
{
    //Afficher tous les secteurs
    public function index()
    {
        return Secteur::all();
    }

    //Ajouter un secteur
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => 'required|string|max:255',
            'abreviation' => 'required|string|max:255',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        \DB::beginTransaction();
        try {
     
            $secteurData = $validated;
            $secteurData['logo'] = 'storage/logo/default.png';

      
            $secteur = Secteur::create($secteurData);

            if ($request->hasFile('logo')) {
                $logoPath = $request->file('logo')->store('logo', 'public');
                $logoPath = 'storage/' . $logoPath;
            } else {
                $logoPath = 'storage/logo/default.png';
            }
            $secteur->update(['logo' => $logoPath]);

            \DB::commit();
            return response()->json($secteur, 201);
        } catch (\Exception $e) {
            \DB::rollback();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    //Afficher un secteur
    public function show(Secteur $secteur)
    {
        return $secteur;
    }

    //Mettre a jour un secteur
   public function update(Request $request, $id)
{
    $secteur = Secteur::findOrFail($id);
        $validated = $request->validate([
            'nom' => 'sometimes|required|string|max:255',
            'abreviation' => 'sometimes|required|string|max:255',
            'logo' => 'sometimes|nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        \DB::beginTransaction();
        try {
          
            if ($request->hasFile('logo')) {
                $logoPath = $request->file('logo')->store('logo', 'public');
                $validated['logo'] = 'storage/' . $logoPath;
            }
            $secteur->update($validated);
            \DB::commit();
            return response()->json($secteur);
        } catch (\Exception $e) {
            \DB::rollback();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
//Supprimer un secteur
public function destroy($id)
{
  $secteur = Secteur::findOrFail($id);
  $secteur->delete();
  return response()->json(['message' => 'Deleted successfully']);
}
}
