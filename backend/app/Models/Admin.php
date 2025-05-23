<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
class Admin extends Authenticatable
{
    use HasFactory,HasApiTokens, Notifiable;

    protected $fillable = [
        'nom', 'prenom', 'email', 'password','fonction', 'telephone', 'status', 'secteur_id','role'
    ];

    protected $hidden = [
        'password',
    ];

    public function secteur()
    {
        return $this->belongsTo(Secteur::class);
    }

  

}
