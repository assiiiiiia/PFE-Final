<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('lots', function (Blueprint $table) {
            $table->id(); 
            $table->unsignedBigInteger('offre_id'); 
            $table->string('numero_lot');
            $table->text('description');
            $table->text('description_ar')->nullable();
            $table->string('document_pdf')->nullable(); 
            $table->enum('statut', ['En cours', 'Attribué', 'Annulé'])->default('En cours');
            $table->timestamps();
            $table->foreign('offre_id')->references('id')->on('offres')->onDelete('cascade');
        });
    }

    public function down() {
        Schema::dropIfExists('lots');
    }
};
