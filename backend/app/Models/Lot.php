<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Lot extends Model {
    use HasFactory;

    protected $fillable = ['offre_id', 'numero_lot', 'description','description_ar', 'statut','document_pdf'];
    
    public function offre() {
        return $this->belongsTo(Offre::class);
    }
    

}
