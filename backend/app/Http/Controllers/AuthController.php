<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use App\Models\User;
use App\Models\Admin;
use App\Models\Entreprise;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function register(Request $request)
{
    $validator = Validator::make($request->all(), [
        'email'           => 'required|email|unique:users',
        'password'        => 'required|min:6|confirmed',
        'civilite'        => 'required',
        'nom'             => 'required',
        'prenom'          => 'required',
        'fonction'        => 'required',
        'telephone'       => 'required',
        'pays'            => 'required',
        'wilaya'          => [Rule::requiredIf($request->pays == 'Algérie')],
        'adresse'         => 'required',
        'nom_entreprise'  => 'required',
        'activite'        => 'required',
        'categorie'       => 'required',
        'code_commerce'   => 'required|unique:entreprises',
        'num_fiscal'      => 'required|unique:entreprises',
        'num_statistique' => 'required|unique:entreprises',
        'num_national'    => 'required|unique:entreprises',
        'nombre_employes' => 'required|min:1',
        'logo'            => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
    ]);

    if ($validator->fails()) {
        return response()->json(['errors' => $validator->errors()], 422);
    }

    \DB::beginTransaction();
    try {
       
        $entreprise = Entreprise::create([
            'nom_entreprise'  => $request->nom_entreprise,
            'activite'        => $request->activite,
            'categorie'       => $request->categorie,
            'pays'            => $request->pays,
            'wilaya'          => $request->wilaya,
            'adresse'         => $request->adresse,
            'code_commerce'   => $request->code_commerce,
            'num_fiscal'      => $request->num_fiscal,
            'num_statistique' => $request->num_statistique,
            'num_national'    => $request->num_national,
            'nombre_employes' => $request->nombre_employes,
            'logo'            => 'storage/logo/default.png', 
        ]);

$logoPath = null;
if ($request->hasFile('logo')) {
    $logoPath = $request->file('logo')->store('logo');
    $logoPath = str_replace('public/', 'storage/', $logoPath); 
} else {
    $logoPath = 'storage/logo/default.png'; 
}


$entreprise->update(['logo' => $logoPath]);

        $user = User::create([
            'email'         => $request->email,
            'password'      => Hash::make($request->password),
            'status'        => 'en attente',
            'civilite'      => $request->civilite,
            'nom'           => $request->nom,
            'prenom'        => $request->prenom,     
            'telephone'     => $request->telephone,
            'fonction'      => $request->fonction,
            'entreprise_id' => $entreprise->id,
        ]);

        $user->notify(new \App\Notifications\EmailVerificationNotification());
        if (!$user) {
            $entreprise->delete();
            throw new \Exception('Erreur lors de la création de l\'utilisateur.');
        }

        \DB::commit();

        return response()->json([
            'message' => 'Inscription réussie!',
            'user'    => [
                'id'    => $user->id,
                'email' => $user->email,
            ]
        ], 201);
    } catch (\Exception $e) {
        \DB::rollBack();
        Log::error('Erreur lors de la création: ' . $e->getMessage());
        return response()->json([
            'error'   => 'Erreur lors de l\'inscription',
            'message' => $e->getMessage()
        ], 500);
    }
}
public function resendVerificationEmail(Request $request)
{
    $user = Auth::user();

    if ($user->hasVerifiedEmail()) {
        return response()->json(['message' => 'Email already verified.'], 400);
    }

    $user->sendEmailVerificationNotification();

    return response()->json(['message' => 'Verification email sent.']);
}public function loginUser(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'password' => 'required',
    ]);

    // Vérifier le reCAPTCHA seulement si un token est fourni (optionnel)
    if ($request->has('recaptchaToken')) {
        $recaptchaResponse = Http::asForm()->post('https://www.google.com/recaptcha/api/siteverify', [
            'secret'   => config('services.recaptcha.secret'),
            'response' => $request->recaptchaToken,
            'remoteip' => $request->ip(),
        ]);

        $recaptchaData = $recaptchaResponse->json();

        if (!isset($recaptchaData['success']) || $recaptchaData['success'] !== true) {
            return response()->json([
                'success' => false,
                'message' => 'reCAPTCHA non validé'
            ], 422);
        }
    }

    // Authentifier l'utilisateur
    $user = User::where('email', $request->email)->first();

    // Vérifier si l'utilisateur existe et si le mot de passe est correct
    if (!$user || !Hash::check($request->password, $user->password)) {
        return response()->json([
            'success' => false,
            'message' => 'Email ou mot de passe incorrect'
        ], 401);
    }

    // Vérification de l'email
    if (!$user->hasVerifiedEmail()) {
        return response()->json([
            'success' => false,
            'message' => 'Veuillez vérifier votre adresse e-mail avant de vous connecter.'
        ], 403);
    }

    // Générer le token et retourner les données utilisateur
    $token = $user->createToken('authToken')->plainTextToken;
    $entreprise = $user->entreprise;

    return response()->json([
        'success' => true,
        'token'   => $token,
        'user'    => [
            'id'             => $user->id,
            'civilite'       => $user->civilite,
            'nom'            => $user->nom,
            'prenom'         => $user->prenom,
            'nom_entreprise' => $entreprise ? $entreprise->nom_entreprise : null,
            'status'         => $user->status_label,
        ]
    ]);
}

//ADMIN login
    public function loginAdmin(Request $request)
    {
        // Validation des champs
        $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);
    
        // Récupérer l'admin par email
        $admin = Admin::where('email', $request->email)->first();
    
        // Vérifier si l'admin existe et si le mot de passe est correct
        if (!$admin || !Hash::check($request->password, $admin->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Email ou mot de passe incorrect'
            ], 401);
        }
    
        // Générer le token d'authentification
        $token = $admin->createToken('admin-token')->plainTextToken;
    
        return response()->json([
            'success' => true,
            'token'   => $token,
            'user'    => [
                'id'        => $admin->id,
                'nom'       => $admin->nom,
                'prenom'    => $admin->prenom,
                'email'     => $admin->email,
                'telephone' => $admin->telephone,
                'role'      => $admin->role,
                'status'    => $admin->status
            ]
        ]);
    }
    
    
//logout 
    public function logout(Request $request)
    {
        try {
            if ($request->user()) {
                $request->user()->tokens()->delete(); 
                return response()->json(['message' => 'Déconnexion réussie'], 200);
            }
            return response()->json(['error' => 'Utilisateur non authentifié'], 401);
        } catch (\Exception $e) {
            return response()->json([
                'error'   => 'Erreur serveur',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Récupérer les informations de l'utilisateur connecté.
     */
    public function getUser(Request $request)
    {
        $user = $request->user();

        if ($user instanceof \App\Models\Admin) {
         
            $user->load('secteur');
        } elseif ($user instanceof \App\Models\User) {
         
            $user->load('entreprise');
        }

        return response()->json($user);
    }
   
}
