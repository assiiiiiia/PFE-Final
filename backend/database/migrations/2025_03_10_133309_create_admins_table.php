<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('admins', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->string('prenom');
            $table->string('email')->unique();
            $table->string('password');
            $table->string('telephone');
            $table->string('fonction')->nullable();
            $table->enum('status', ['actif', 'inactif'])->default('actif');
            $table->foreignId('secteur_id')->nullable()->constrained('secteurs')->onDelete('cascade');
            $table->enum('role', ['admin', 'superadmin'])->default('admin');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('admins');
    }
};

