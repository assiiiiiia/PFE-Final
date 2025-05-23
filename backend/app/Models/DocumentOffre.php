<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DocumentOffre extends Model
{
    use HasFactory;

    protected $table = 'documents_offre';

    protected $fillable = [
        'offre_id',

        // Français
        'document_pdf',
        'document_annulation',
        'document_infructueux',
        'document_prorogation',
        'journal',

        // Arabe
        'document_pdf_ar',
        'document_annulation_ar',
        'document_infructueux_ar',
        'document_prorogation_ar',
        'journal_ar',
    ];

    public function offre()
    {
        return $this->belongsTo(Offre::class);
    }
}
