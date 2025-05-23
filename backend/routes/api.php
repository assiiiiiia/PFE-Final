<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EntrepriseController;
use App\Http\Controllers\AdminProfileController;
use App\Http\Controllers\SuperAdminController;
use App\Http\Controllers\OffreController;
use App\Http\Controllers\SoumissionController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\Admin\StatistiqueController;
use App\Http\Controllers\SecteurController;
use App\Http\Controllers\Auth\EmailVerificationController;
use App\Http\Controllers\SuggestionController;
Route::get('/', function () {
    return 'API';
});

// Authentification
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'loginUser']);
Route::post('/admin/login', [AuthController::class, 'loginAdmin']);
Route::post('/suggestions', [SuggestionController::class, 'store'])->name('suggestions.store');
Route::get('/offres/search', [OffreController::class, 'search']);
Route::get('/email/verify/{id}/{hash}', [EmailVerificationController::class, 'verify'])
    ->middleware(['signed'])
    ->name('verification.verify');

    Route::middleware(['auth:sanctum'])->post('/email/resend', [EmailVerificationController::class, 'resend']);
    Route::post('/email/custom-resend', [EmailVerificationController::class, 'customResend']);
    Route::get('/email/verification-status', [EmailVerificationController::class, 'checkVerificationStatus']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [AuthController::class, 'getUser']);
    Route::post('/logout', [AuthController::class, 'logout']);
});


// Gestion des utilisateurs coté  Super admin 
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/users', [SuperAdminController::class, 'Users']);
    Route::delete('/users/{id}', [SuperAdminController::class, 'destroyUser']);
    Route::get('/users/pending', [SuperAdminController::class, 'getPendingUsers']);
    
});
Route::middleware('auth:sanctum')->group(function () {
   
    Route::get('/suggestions', [SuggestionController::class, 'index']);
    
});
//profil admin
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/admin/profile', [AdminProfileController::class, 'show']);
    Route::put('/admin/profile', [AdminProfileController::class, 'update']);


});

// Gestion des Admins coté Super admin 
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/admin/register', [SuperAdminController::class, 'registerAdmin']);  
    Route::get('/admin', [SuperAdminController::class, 'index']); 
    Route::post('/admin', [SuperAdminController::class, 'registerUser']); 
    Route::put('/admin/{id}', [SuperAdminController::class, 'update']); 
    Route::delete('/admin/{id}', [SuperAdminController::class, 'destroy']);
    Route::get('/admin/stats', [StatistiqueController::class, 'getStats']);


});
  // Gestion des secteur coté Super admin 
  Route::middleware('auth:sanctum')->group(function () {
    Route::get('/secteurs', [SecteurController::class, 'index']);
    Route::post('/secteurs', [SecteurController::class, 'store']);
    Route::put('/secteurs/{id}', [SecteurController::class, 'update']);
    Route::delete('/secteurs/{id}', [SecteurController::class, 'destroy']);

});


//Gestion des soumissions coté admin
Route::middleware('auth:sanctum')->group(function () {
  
    Route::get('/soumissions', [SoumissionController::class, 'index']);
    Route::get('/soumissions/{id}', [SoumissionController::class, 'show']);
    Route::put('/soumissions/{id}', [SoumissionController::class, 'update']);
});


//statestique
Route::middleware(['auth:sanctum'])->prefix('admin')->group(function () {
    Route::get('/stats', [StatistiqueController::class, 'getStats']);  //Top cards
    Route::get('/detailed-offer-stats', [StatistiqueController::class, 'getDetailedOfferStats']); //Pie chart
    Route::get('/offer-trend-stats', [StatistiqueController::class, 'getOfferTrendStats']); //Line chart
    Route::get('/offer-cards-stats', [StatistiqueController::class, 'getDashboardInfos']);  //side cards 
    Route::get('/admin-offer-stats', [StatistiqueController::class, 'getUserOfferStats']); // Statistiques Admins nombre d'offres créées
    Route::get('/offre-wilayas', [StatistiqueController::class, 'getOffersByTypeAndWilaya']); 
    Route::get('/top-soumissions', [StatistiqueController::class, 'getTopSoumissionsByOffre']);

    Route::get('/admin-offer-stats-weekly', [StatistiqueController::class, 'getAdminOfferStatsWeekly']);    // Statistiques des administrateurs : nombre d'offres créées par semaine
    Route::get('/admin-offer-stats-monthly', [StatistiqueController::class, 'getAdminOfferStatsMonthly']);// Statistiques des administrateurs : nombre d'offres créées par mois
    Route::get('/soumission-stats', [StatistiqueController::class, 'getSoumissionStats']);    // Statistiques des soumissions : nombre de soumissions par offre et total général
    Route::get('/total-offers', [StatistiqueController::class, 'getTotalOffers']); // Nombre total des offres créées par l'entreprise
    Route::get('/additional-stats', [StatistiqueController::class, 'getAdditionalStats']);// Autres statistiques recommandées (répartition par wilaya, durée moyenne, tendance mensuelle)
});

//Notifications utilisateur apres soumission
Route::middleware('auth:sanctum')->get('/notifications', function () {
    return \DB::table('notifications_custom')
        ->where('user_id', auth()->id())
        ->orderBy('created_at', 'desc')
        ->get();
});

Route::middleware('auth:sanctum')->post('/notifications/{id}/read', function ($id) {
    return \DB::table('notifications_custom')
        ->where('id', $id)
        ->update(['is_read' => true]);
});
Route::middleware('auth:sanctum')->post('/notifications/mark-all-read', function () {
    return \DB::table('notifications_custom')
        ->where('user_id', auth()->id())
        ->update(['is_read' => true]);
});
Route::middleware('auth:sanctum')->delete('/notifications/{id}', function ($id) {
    return \DB::table('notifications_custom')
        ->where('id', $id)
        ->where('user_id', auth()->id())
        ->delete();
});

// Affichage public des Offres coté user (appel d'offre , avis de consulation , avis de manifestation)
Route::get('/entreprises', [EntrepriseController::class, 'index']);
Route::get('/offres-pub', [OffreController::class, 'index']);
Route::get('/offres-pub/{id}', [OffreController::class, 'show']);
Route::get('/secteurs', [SecteurController::class, 'index']);


//Affichage des favoris pour utilisateur 
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/favorites', [FavoriteController::class, 'index']);
    Route::post('/favorites', [FavoriteController::class, 'store']);
    Route::delete('/favorites/{id}', [FavoriteController::class, 'destroy']);
});
//Affichage soumissions coté utilisateur 
Route::middleware('auth:sanctum')->group(function () { 
    Route::post('/soumissions', [SoumissionController::class, 'store']);
    Route::get('user/soumissions', [SoumissionController::class, 'getUserSoumission']);
});


//Affichage offres coté admin 
Route::middleware('auth:sanctum')->group(function () {
    
    Route::post('/offres', [OffreController::class, 'store']);
    Route::get('/offres', [OffreController::class, 'getPublications']);
    Route::get('/offres/{id}', [OffreController::class, 'show']);
    Route::put('/offres/{id}', [OffreController::class, 'update']);
    Route::delete('/offres/{offre}', [OffreController::class, 'destroy']);
});



 //gestion profile
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [ProfileController::class, 'show']); 
    Route::put('/profile', [ProfileController::class, 'update']); 
});

