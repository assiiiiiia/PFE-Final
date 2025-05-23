<?php

namespace App\Http\Controllers;

use App\Models\Lot;
use Illuminate\Http\Request;

class LotController extends Controller
{
    public function update(Request $request, Lot $lot)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'description_ar' => 'nullable|string',
        ]);

        if ($request->has('description_ar')) {
            $lot->description_ar = $request->description_ar;
        }

        $lot->update($validatedData);

        return response()->json([
            'message' => 'Lot updated successfully',
            'lot' => $lot,
        ]);
    }
}