<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Admin;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;


class SuperAdminController extends Controller
{
    // Récupérer tous les Admins
    public function index()
    {
            return response()->json(Admin::with('secteur')->get());

    }
    
    // Récupérer tous les utilisateurs
    public function Users(Request $request)
    {
        $user = $request->user(); 
    
        if ($user->role === 'superadmin') {
            return response()->json(User::with('entreprise')->get());
        }
    
        return response()->json(['error' => 'Accès non autorisé'], 403);
    }
    

    // Récupérer les utilisateurs en attente
    public function getPendingUsers()
    {
        $users = User::where('status', 'en attente')->get(['id', 'nom', 'prenom', 'status', 'email']);
        return response()->json($users, 200);
    }

   // Ajouter un administrateur
   public function registerAdmin(Request $request)
   {
       $validator = Validator::make($request->all(), [
           'email'     => 'required|email|unique:admins',
           'password'  => 'required|min:6|confirmed',
           'nom'       => 'required',
           'prenom'    => 'required',
           'fonction'  => 'nullable',
           'telephone' => 'required|string',
           'secteur_id' => 'nullable|exists:secteurs,id',
       ]);
   
       if ($validator->fails()) {
           return response()->json(['errors' => $validator->errors()], 422);
       }
   
       $admin = Admin::create([
           'email'     => $request->email,
           'password'  => Hash::make($request->password),
           'nom'       => $request->nom,
           'prenom'    => $request->prenom,
           'telephone' => $request->telephone,
           'fonction'      => $request->fonction,
           'secteur_id' => $request->secteur_id,
           'status'    => 'actif',
       ]);
   
       return response()->json(['message' => 'Administrateur ajouté avec succès', 'admin' => $admin], 201);
   }
// mettre a jour un admin 
   public function update(Request $request, $id)
   {
       $admin = Admin::find($id);
   
       if (!$admin) {
           return response()->json(['error' => 'Administrateur non trouvé'], 404);
       }
   
       $rules = [
           'email'        => 'required|email|unique:admins,email,' . $id,
           'nom'          => 'required|string',
           'prenom'       => 'required|string',
           'telephone'    => 'required|string',
           'fonction' => 'nullable|string|max:255',
           'status'       => 'required|in:actif,inactif',
           'secteur_id' => 'required|exists:secteurs,id',
       ];
   
       if ($request->filled('password')) {
           $rules['password'] = 'min:6|confirmed';
       }
   
       $validator = Validator::make($request->all(), $rules);
       if ($validator->fails()) {
           return response()->json(['errors' => $validator->errors()], 422);
       }
   
      
       $data = $request->only(['email', 'nom', 'prenom','fonction', 'telephone', 'status', 'secteur_id']);
   
      
       if ($request->filled('password')) {
           $data['password'] = Hash::make($request->password);
       }
   
       $admin->update($data);
   
       return response()->json(['message' => 'Administrateur mis à jour avec succès', 'admin' => $admin]);
   }
   

   // Supprimer un administrateur
public function destroy($id)
{
    $admin = Admin::find($id);

    if (!$admin) {
        return response()->json(['error' => 'Administrateur non trouvé'], 404);
    }

    $admin->delete();

    return response()->json(['message' => 'Administrateur supprimé avec succès']);
}

   // Supprimer un utilisateur
   public function destroyUser($id)
   {
       $user = User::find($id);
   
       if (!$user) {
           return response()->json(['error' => 'Utilisateur non trouvé'], 404);
       }
   
       $user->delete();
   
       return response()->json(['message' => 'utilisateur supprimé avec succès']);
   }

  
}
