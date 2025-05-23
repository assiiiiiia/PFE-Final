<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateHistoriqueSoumissionsTable extends Migration
{
    public function up()
    {
        Schema::create('historique_soumissions', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('soumission_id');
            $table->unsignedBigInteger('admin_id');
            $table->string('ancien_statut')->nullable();
            $table->string('nouveau_statut');
            $table->text('ancien_commentaire')->nullable();
            $table->text('nouveau_commentaire')->nullable();
            $table->timestamp('date_modification');
            $table->timestamps();

            $table->foreign('soumission_id')->references('id')->on('soumissions')->onDelete('cascade');
            $table->foreign('admin_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::dropIfExists('historique_soumissions');
    }
}