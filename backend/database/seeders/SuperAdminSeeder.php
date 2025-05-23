<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\Admin;
class SuperAdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        
            Admin::create([ 
                'nom' => 'Super',
                'prenom' => 'Admin',
                'email' => 'superadmin@e.com',
                'password' => Hash::make('superadmin'), 
                'telephone' => '0654321890',
                'status' => 'actif',
                'secteur_id' => null, 
                'role' => 'superadmin',
            ]);
    
            Admin::create([
                'nom' => 'at',
                'prenom' => 'Admin',
                'email' => 'admin@e.com',
                'password' => Hash::make('admin123'), 
                'telephone' => '0654321890',
                'status' => 'actif',
                'secteur_id' => 1,  
                'role' => 'admin',
            ]);
        }
}
