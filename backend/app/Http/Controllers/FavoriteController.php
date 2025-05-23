<?php
namespace App\Http\Controllers;
use App\Models\Favorite;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FavoriteController extends Controller
{
    public function index()
    {
        try {
            $userId = Auth::id(); 
            $favorites = Favorite::with('offre.secteur')
                            ->where('user_id', $userId)
                            ->get();
    
            return response()->json($favorites);
        } catch (\Exception $e) {
            \Log::error('Error fetching favorites: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to fetch favorites'], 500);
        }
    }
    

    public function store(Request $request)
    {
        $user = Auth::user();

        $existingFavorite = Favorite::where('user_id', $user->id)
                                    ->where('offre_id', $request->offre_id)
                                    ->first();

        if ($existingFavorite) {
            return response()->json(['message' => 'Favorite already exists.'], 409);
        }

        $favorite = Favorite::create([
            'user_id' => $user->id,
            'offre_id' => $request->offre_id,
        ]);

        return response()->json($favorite, 201);
    }

    public function destroy($id)
    {
        $user = Auth::user();
        $favorite = Favorite::where('user_id', $user->id)->where('id', $id)->first();

        if ($favorite) {
            $favorite->delete();
            return response()->json(['message' => 'Favorite removed successfully.'], 200);
        }

        return response()->json(['message' => 'Favorite not found.'], 404);
    }
}
