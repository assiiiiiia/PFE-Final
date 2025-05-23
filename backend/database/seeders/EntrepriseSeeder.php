<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Entreprise;
use Illuminate\Support\Facades\DB;

class EntrepriseSeeder extends Seeder
{
    public function run()
    {
     
        $entreprises = [
            [
                'id' => 1, 
                'nom_entreprise' => 'Ministère de la Poste et des Télécommunications',
                'activite' => 'Télécommunications',
                'categorie' => 'Public',
                'pays' => 'Algérie',
                'wilaya' => 'Alger',
                'adresse' => 'Adresse non définie',
                'code_commerce' => 'mpt',
                'num_fiscal' => 'mpt-FISCAL',
                'num_statistique' => 'mpt-STAT',
                'num_national' => 'mpt-NAT',
                'nombre_employes' => '0',
                'logo' => 'storage/logo/logo-ministere.png',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];

     
        DB::table('entreprises')->insert($entreprises);
    }
}