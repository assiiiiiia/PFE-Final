<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Auth\Events\Verified;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class EmailVerificationController extends Controller
{
    public function verify(Request $request)
    {
        $user = User::findOrFail($request->route('id'));

        if (!$user->hasVerifiedEmail()) {
            $user->markEmailAsVerified();
            $user->status = 'actif';
            $user->save();
            event(new Verified($user));
        }

        // Redirige vers le frontend Vue
        return redirect()->away(config('app.frontend_url') . '/email-verified-success');
    }
    
    public function resend(Request $request)
    {
        $user = Auth::user();

        if ($user->hasVerifiedEmail()) {
            return response()->json(['message' => 'Votre e-mail est déjà vérifié.'], 400);
        }

        $user->notify(new EmailVerificationNotification($user->prenom));

        return response()->json(['message' => 'Lien de vérification renvoyé avec succès.']);
    }

    public function customResend(Request $request)
    {
        $user = User::latest()->first();

        if (!$user) {
            return response()->json(['message' => 'Aucun utilisateur trouvé.'], 404);
        }

        if ($user->hasVerifiedEmail()) {
            return response()->json(['message' => 'Cet e-mail est déjà vérifié.', 'email' => $user->email], 400);
        }

        $user->sendEmailVerificationNotification();

        return response()->json(['message' => 'E-mail de vérification renvoyé avec succès à ' . $user->email, 'email' => $user->email]);
    }

    public function checkVerificationStatus(Request $request)
    {
        $user = User::latest()->first();

        if (!$user) {
            return response()->json(['message' => 'Aucun utilisateur trouvé.', 'email' => null], 404);
        }

        return response()->json(['isVerified' => $user->hasVerifiedEmail(), 'email' => $user->email]);
    }
}
