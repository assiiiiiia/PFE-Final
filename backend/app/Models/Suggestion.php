<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\User;

class Suggestion extends Model
{
    protected $fillable = [
   
        'email',
        'content',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
