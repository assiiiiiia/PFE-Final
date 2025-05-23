<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});
Route::get('/email-verified-success', function () {
    return view('email-verified-success'); // Returns the view for email verification success
});
