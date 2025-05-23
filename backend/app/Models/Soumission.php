<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\User;
use App\Models\Entreprise;
use App\Models\Offre;
use App\Models\DocumentSoumission;

class Soumission extends Model
{
    protected $fillable = ['user_id', 'offre_id', 'statut', 'commentaire_admin','proposition'];


  
    public function user()
    {
        return $this->belongsTo(User::class);
    }

  
 
    public function offre()
    {
        return $this->belongsTo(Offre::class);
    }
    

    public function documents()
    {
        return $this->hasMany(DocumentSoumission::class);
    }
}
