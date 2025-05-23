<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('offres', function (Blueprint $table) {
            $table->id();
            $table->foreignId('secteur_id')->constrained('secteurs')->onDelete('cascade');
            $table->foreignId('admin_id')->constrained('admins')->onDelete('cascade');
            $table->string('langue')->default('Français');
            $table->string('etat_offre')->default('En Cours');
            $table->string('wilaya')->nullable();
            $table->string('numero_offre')->unique();
            $table->string('titre_offre');
            $table->string('titre_offre_ar')->nullable();
            $table->enum('type_offre', ["Appel d''offre", "Avis de consultation", "Avis de manifestation"]);
            $table->enum('niveau', ['National', 'International'])->default('National');
            $table->date('date_publication');
            $table->date('date_limite')->nullable();
            $table->date('date_prorogation')->nullable();
            $table->text('description')->nullable();
            $table->text('description_ar')->nullable();
            $table->string('etat')->default('En rédaction');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('offres');
    }
};
