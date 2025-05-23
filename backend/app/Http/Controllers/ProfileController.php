<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class ProfileController extends Controller
{
    public function update(Request $request)
    {
        $user = Auth::user(); 

       
        $request->validate([
            'civilite' => 'nullable|string|max:10',
            'nom' => 'required|string|max:255',
            'prenom' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users,email,' . $user->id,
            'fonction' => 'nullable|string|max:255',
            'telephone' => 'required|string|max:20',
            'password' => 'nullable|string|min:6'
        ]);

      
        $user->civilite = $request->civilite;
        $user->nom = $request->nom;
        $user->prenom = $request->prenom;
        $user->email = $request->email;
        $user->fonction = $request->fonction;
        $user->telephone = $request->telephone;

        if ($request->filled('password')) {
            $user->password = Hash::make($request->password);
        }

        $user->save(); 

        return response()->json([
            'message' => 'Profil mis à jour avec succès',
            'user' => $user
        ], 200);
    }

    public function show()
    {
        $user = Auth::user()->load('entreprise');
        return response()->json($user);
    }
}
