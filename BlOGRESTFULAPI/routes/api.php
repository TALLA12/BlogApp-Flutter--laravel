<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CommentController;
use App\Http\Controllers\Api\LikeController;
use App\Http\Controllers\Api\PostController;



/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::group(['middleware'=>'api'],function(){
    

    Route::post('register',[AuthController::class,'register']);
    Route::post('login',[AuthController::class,'login']);
});
Route::group(['middleware'=>['auth:sanctum']],function(){

    Route::get('/user',[AuthController::class,'user']);
    Route::put('/user',[AuthController::class,'update']);
    Route::get('logout',[AuthController::class,'logout']);


    Route::get('/posts',[PostController::class,'index']);
    Route::post('/posts',[PostController::class,'store']);
    Route::get('/posts/{id}',[PostController::class,'show']);
    Route::put('/posts/{id}',[PostController::class,'update']);
    Route::delete('/posts/{id}',[PostController::class,'destroy']);


    Route::get('/posts/{id}/comments',[CommentController::class,'index']);
    Route::post('/posts/{id}/comments',[CommentController::class,'store']);
    Route::get('/comments/{id}',[CommentController::class,'show']);
    Route::put('/comments/{id}',[CommentController::class,'update']);
    Route::delete('/comments/{id}',[CommentController::class,'delete']);


    Route::post('/posts/{id}/likes',[LikeController::class,'likeorunlike']);
});
