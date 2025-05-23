<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Entreprise extends Model
{
    use HasFactory;

    protected $fillable = [
        'nom_entreprise', 'activite', 'categorie', 'pays', 'wilaya', 'adresse','logo',
        'code_commerce', 'num_fiscal', 'num_statistique', 'num_national', 'nombre_employes'
    ];

    public function users()
    {
        return $this->hasMany(User::class); 
    }
 
}