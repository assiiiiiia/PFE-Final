<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SecteurSeeder extends Seeder
{
    public function run()
    {
        $secteurs = [
            [
                'nom' => 'Ministère de la Poste et des Télécommunications',
                'logo' => 'storage/logo/logo-ministere.png',
                'abreviation' => 'MDPT',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'Agence Nationale des Fréquences',
                'logo' => 'storage/logo/logo-anf.png',
                'abreviation' => 'ANF',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'Algérie Poste',
                'logo' => 'storage/logo/logo-poste.png',
                'abreviation' => 'AP',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => "Institut National de la Poste et des Technologies de l'Information et de la Communication",
                'logo' => 'storage/logo/logo-inptic.png',
                'abreviation' => 'INPTIC',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => "Ecole Nationale Supérieure des Télécommunications et des Technologies de l'Information et de la Communication	",
                'logo' => 'storage/logo/logo-inttic.png',
                'abreviation' => 'INTTIC',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'Le Groupe Télécom Algérie',
                'logo' => 'storage/logo/logo-gta.png',
                'abreviation' => 'GTA',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'Algérie Télécom',
                'logo' => 'storage/logo/logo-at.png',
                'abreviation' => 'AT',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'Mobilis',
                'logo' => 'storage/logo/logo-mobilis.png',
                'abreviation' => 'Mobilis',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'Algérie Télécom Satellite',
                'logo' => 'storage/logo/logo-ats.png',
                'abreviation' => 'ATS',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'SATICOM',
                'logo' => 'storage/logo/logo-saticom.png',
                'abreviation' => 'S',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'Compagnie des infrastructures de télécom AlgérieL',
                'logo' => 'storage/logo/logo-comintal.png',
                'abreviation' => 'C',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'Agence Nationale de Promotion & de Développement des Parcs Technologiques',
                'logo' => 'storage/logo/logo-natp.png',
                'abreviation' => 'ANPT',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => "Entreprise d'Appui au Developpement Numérique",
                'logo' => 'storage/logo/logo-numirisation.png',
                'abreviation' => 'EADN',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => "L'Agence Nationale de Promotion et de Développement des Parcs Technologiques	",
                'logo' => 'storage/logo/logo-eci-tic.png',
                'abreviation' => 'ECI TIC',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'NetBeOpen Prime',
                'logo' => 'storage/logo/logo-netbeopen.png',
                'abreviation' => 'NBP',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'WhiteBay Limited',
                'logo' => 'storage/logo/logo-wb.png',
                'abreviation' => 'WBL',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nom' => 'EMS CHAMPION POSTE ALGERIA',
                'logo' => 'storage/logo/logo-ems.png',
                'abreviation' => 'EMS',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];

        DB::table('secteurs')->insert($secteurs);
    }
}

