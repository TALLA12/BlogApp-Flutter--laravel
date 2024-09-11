<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Post;
use App\Models\Comment;

class CommentController extends Controller
{

    public function index($id){
        $post = Post::find($id);
    
        if (!$post){
            return response()->json([
                'message' => 'Post introuvable'
            ], 403);
        }
    
        return response()->json([
            'comments' => $post->comments()->with('user:id,name,image')->get()
        ], 200);
    }
 
       
    public function store(Request $request, $id){
        $post = Post::find($id);
    
        if (!$post){
            return response()->json([
                'message' => 'Post introuvable'
            ], 403); // Utilisation du code de statut 404 pour indiquer que la ressource n'a pas été trouvée.
        }
    
        // Le bloc de validation et de création doit être en dehors du bloc if (!$post)
        $attrs = $request->validate([
            'comment' => 'required|string'
        ]);
    
        Comment::create([
            'comment' => $attrs['comment'],
            'post_id' => $id,
            'user_id' => auth()->user()->id
        ]);
    
        return response()->json([
            'message' => 'Commentaire créé.'
        ], 200);
    }
   
    public function update(Request $request, $id)
{
    $comment = Comment::find($id);

    if (!$comment){
        return response()->json([
            'message' => 'Comment not found.'
        ], 403); 
    }

    if ($comment->user_id != auth()->user()->id){
        return response()->json([
            'message' => 'Permission denied'
        ], 403);
    }

    
    $attrs = $request->validate([
        'comment' => 'required|string'
    ]);

    $comment->update([
        'comment' => $attrs['comment']
    ]);

    return response()->json([
        'message' => 'Commentaire mis à jour'
    ], 200);
}
public function delete($id){
    $comment = Comment::find($id);

    if (!$comment){
        return response()->json([
            'message' => 'Commentaire introuvable'
        ], 403); 
    }

    if ($comment->user_id != auth()->user()->id){
        return response()->json([
            'message' => 'Permission refusée'
        ], 403);
    }

    $comment->delete();

    return response()->json([
        'message' => 'Commentaire supprimé'
    ], 200);
}

    
    
}
