<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Offre extends Model
{
    use HasFactory;

    protected $fillable = [
        'secteur_id',
        'admin_id',
        'langue',
        'etat_offre',
        'wilaya',
        'numero_offre',
        'titre_offre',
        'titre_offre_ar',
        'type_offre',
        'niveau',
        'date_publication',
        'date_limite',
        'date_prorogation',
        'description',
        'description_ar',
        'journal',
        'etat',
        'a_des_lots',
    ];

    public function secteur()
    {
        return $this->belongsTo(Secteur::class);
    }
    public function documents()
    {
        return $this->hasOne(DocumentOffre::class);
    }
    public function lots()
    {
        return $this->hasMany(Lot::class);
    }
 
}
