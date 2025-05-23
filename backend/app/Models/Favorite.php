<?php
namespace App\Models;
use App\Models\User;
use App\Models\Offre;
use Illuminate\Database\Eloquent\Model;

class Favorite extends Model
{
    protected $fillable = [
        'user_id',
        'offre_id',
    ];


    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function offre()
    {
        return $this->belongsTo(Offre::class);
    }
    
}
