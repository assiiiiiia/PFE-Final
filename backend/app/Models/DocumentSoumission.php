<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class DocumentSoumission extends Model
{
    protected $table = 'document_soumissions';
    protected $fillable = ['soumission_id', 'nom_fichier', 'chemin_fichier'];
}
