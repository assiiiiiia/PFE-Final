<?php

namespace App\Http\Controllers;

use App\Models\Suggestion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;

class SuggestionController extends Controller
{
    public function index()
{
    $suggestions = Suggestion::all();

    return response()->json($suggestions);
}
    public function store(Request $request)
    {

        $rules = [
            'content' => ['required', 'string', 'min:5'],
           
        ];
    
        if (Auth::check()) {
     
            $email = Auth::user()->email;
          
        } else {
          
            $rules['email'] = [
                'required',
                'email',
                Rule::exists('users', 'email'),
            ];
            $email = $request->input('email');
           
        }
    
        $validated = $request->validate($rules);
    
       
        $suggestion = Suggestion::create([
    
            'email'   => $email,
            'content' => $validated['content'],
        ]);
    
        return response()->json([
            'message'    => 'Suggestion envoyée avec succès.',
            'suggestion' => $suggestion,
        ], 201);
    }
    
}
