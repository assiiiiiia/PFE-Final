<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;

class AdminProfileController extends Controller
{
    public function show(Request $request)
    {
        return response()->json($request->user());
    }
    
    public function update(Request $request)
    {
        $user = $request->user();
    
        $request->validate([
            'nom' => 'nullable|string|max:255',
            'prenom' => 'nullable|string|max:255',
            'telephone' => 'nullable|string|max:255',
            'email' => 'nullable|email|max:255|unique:users,email,' . $user->id,
            'password' => 'nullable|string|min:6|confirmed',
            'password_confirmation' => 'nullable|string|min:6',
        ]);
    
        if ($request->filled('nom')) {
            $user->nom = $request->nom;
        }
        if ($request->filled('prenom')) {
            $user->prenom = $request->prenom;
        }
        if ($request->filled('telephone')) {
            $user->telephone = $request->telephone;
        }
    
        if ($request->filled('email')) {
            $user->email = $request->email;
        }
    
        if ($request->filled('password')) {
            $user->password = Hash::make($request->password);
        }

        $user->save();

        return response()->json([
            'message' => 'Profil mis à jour avec succès',
            'user' => $user,
        ]);
    }
    
    
}