<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('entreprises', function (Blueprint $table) {
            $table->engine = 'InnoDB'; 
            $table->id();
            $table->string('nom_entreprise');
            $table->string('activite');
            $table->string('categorie');
            $table->string('pays');
            $table->string('wilaya')->nullable(); 
            $table->string('adresse');
            $table->string('code_commerce')->unique();
            $table->string('num_fiscal')->unique();
            $table->string('num_statistique')->unique();
            $table->string('num_national')->unique();
            $table->string('nombre_employes');
            $table->string('logo')->nullable()->comment('Chemin ou URL du logo de l\'entreprise');
            $table->timestamps();
        });
    }
    
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('entreprises');
    }
};
