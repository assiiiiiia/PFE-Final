<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('documents_offre', function (Blueprint $table) {
            $table->id();
            $table->foreignId('offre_id')->constrained()->onDelete('cascade');
        
            // Documents en français
            $table->string('document_pdf')->nullable();
            $table->string('document_annulation')->nullable();
            $table->string('document_infructueux')->nullable();
            $table->string('document_prorogation')->nullable();
            $table->string('journal')->nullable();
        
            // Documents en arabe
            $table->string('document_pdf_ar')->nullable();
            $table->string('document_annulation_ar')->nullable();
            $table->string('document_infructueux_ar')->nullable();
            $table->string('document_prorogation_ar')->nullable();
            $table->string('journal_ar')->nullable();
        
            $table->timestamps();
        });
        
    }

    public function down(): void
    {
        Schema::dropIfExists('documents_offre');
    }
};

