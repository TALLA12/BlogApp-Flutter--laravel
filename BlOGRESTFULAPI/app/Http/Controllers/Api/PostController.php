<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Post;

class PostController extends Controller
{
    public function index()
    {
        // Récupère les publications avec plusieurs relations et compteurs associés
        $posts = Post::orderBy('created_at', 'desc')
            ->with('user:id,name,image') // Charge la relation 'user' avec les colonnes spécifiées
            ->withCount('comments', 'likes') // Compte le nombre de commentaires et de likes pour chaque publication
            ->with('likes', function ($like) {
                // Charge la relation 'likes' avec une sous-relation filtrée pour l'utilisateur actuel
                return $like->where('user_id', auth()->user()->id)
                    ->select('id', 'user_id', 'post_id')
                    ->get();
            })
            ->get();
    
        // Retourne la réponse JSON avec les publications
        return response()->json([
            'posts' => $posts
        ], 200);
    }

    

public function show($id){
    $posts=Post::where('id',$id)->withCount('comments','likes')->get();
    return response()->json([
         'posts'=>$posts
    ],200);
}


public function store(Request $request){
    $attr = $request->validate([
        'body' => 'required|string'
    ]);
    $image=$this->saveImage($request->image,'posts');


    $post = Post::create([
        'body' => $attr['body'],
        'user_id' => auth()->user()->id,
          'image'=>$image
    ]);

    return response()->json([
        'message' => 'Post créé',
        'post' => $post
    ], 200);
}


public function update(Request $request, $id){
    $post = Post::find($id);

    if (!$post){
        return response()->json([
            'message' => 'Post introuvable',
        ], 403); 
    }

    if ($post->user_id != auth()->user()->id){
        return response()->json([
            'message' => 'Permission refusée'
        ], 403);
    }

    $attr = $request->validate([
        'body' => 'required|string'
    ]);

    $post->update([
        'body' => $attr['body']
    ]);

    return response()->json([
        'message' => 'Post mis à jour',
        'post' => $post
    ], 200);
}


public function destroy($id){
    $post = Post::find($id);

    if (!$post){
        return response()->json([
            'message' => 'Post introuvable',
        ], 403); 
    }

    if($post->user_id != auth()->user()->id){
        return response()->json([
            'message' => 'Permission refusée'
        ], 403);
    }

    $post->comments()->delete();
    $post->likes()->delete();
    $post->delete(); // Correction ici : changé $posts en $post

    return response()->json([
        'message' => 'Post supprimé',
    ], 200);
}


}





