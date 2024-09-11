<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Like;
use App\Models\Post;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    public function likeorunlike($id){
        $post = Post::find($id);

        if (!$post){
            return response()->json([
                'message' => 'Post introuvable'
            ], 403); 
        }

        $like = $post->likes()->where('user_id', auth()->user()->id)->first();

        if (!$like){
            Like::create([
                'post_id' => $id,
                'user_id' => auth()->user()->id
            ]);

            return response()->json([
                'message' => 'Liked'
            ], 200);
        }

        $like->delete();

        return response()->json([
            'message' => 'Disliked'
        ], 200);
    }
}
