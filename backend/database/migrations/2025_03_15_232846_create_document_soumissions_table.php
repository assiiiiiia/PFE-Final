<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('document_soumissions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('soumission_id')->constrained('soumissions')->onDelete('cascade');
            $table->string('nom_fichier');
            $table->string('chemin_fichier');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('document_soumissions');
    }
};
