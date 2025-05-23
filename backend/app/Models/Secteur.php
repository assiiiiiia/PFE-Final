<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Secteur extends Model
{
    use HasFactory;

    protected $fillable = [
        'logo',
        'nom',
        'abreviation',
    ];
    public function Offres()
    {
        return $this->hasMany(Offre::class, 'secteur_id');
    }
    public function Admins()
    {
        return $this->hasMany(Offre::class, 'admin_id');
    }
}
