<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Database\Seeders\SecteurSeeder; 
use Database\Seeders\EntrepriseSeeder; // Corrected spelling of EntrepriseSeeder

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
     
        $this->call([
            SecteurSeeder::class,
            EntrepriseSeeder::class, 
            UserSeeder::class,
            SuperAdminSeeder::class,
         
        ]);

        User::create([
            'nom' => 'Super',
            'prenom' => 'Admin',
            'email' => 'admin@e.com',
            'password' => Hash::make('superadmin'),
            'telephone' => '05555555555',
            'status' => 'actif',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
