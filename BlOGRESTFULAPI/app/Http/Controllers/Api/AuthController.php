<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User; // Import the User model

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $req = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6|confirmed',
        ]);

        $user = User::create([
            'name' => $req['name'],
            'email' => $req['email'],
            'password' => bcrypt($req['password']),
        ]);

        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken,
        ]);
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            $token = $user->createToken('secret')->plainTextToken;

            return response(['user' => $user, 'token' => $token]);
        }

        return response(['message' => 'Invalid credentials'], 401);
    }

    public function logout()
    {
        auth()->user()->tokens()->delete();
        return response([
            'message' => 'Logout success.'
        ]);
    }

    public function user()
    {
        return response([
            'user' => Auth::user(),
        ], 200);
    }
    public function update(Request $request)
    {
        // Validation des données du formulaire
        $attr = $request->validate([
            'name' => 'required|string',
        ]);
    
        
        $image = $this->saveImage($request->image, 'profiles');
    
        // Mise à jour de l'utilisateur
        auth()->user()->update([
            'name' => $attr['name'],
            'image' => $image, // Peut être null si aucune image n'est fournie
        ]);
    
        // Réponse JSON
        return response([
            'message' => 'Utilisateur mis à jour',
            'user' => auth()->user(),
        ], 200);
    }
    
}
