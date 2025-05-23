<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run()
    {
        User::create([
            'email'      => 'user@test.com',
            'password'   => Hash::make('password'),
            'status'     => 'actif',
            'civilite'   => 'Madame',
            'nom'        => 'User',
            'prenom'     => 'Test',
            'telephone' =>'055555555',
            'fonction'   => 'Directeur',
            'entreprise_id' => 1,
        ]);
    }
}


