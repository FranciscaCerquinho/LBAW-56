<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return redirect('auctions');
});



//User
Route::get('editProfile', 'UserController@show');
Route::post('editProfile', 'UserController@update');

// API
Route::put('api/cards', 'CardController@create');
Route::delete('api/cards/{card_id}', 'CardController@delete');
Route::put('api/cards/{card_id}/', 'ItemController@create');
Route::post('api/item/{id}', 'ItemController@update');
Route::delete('api/item/{id}', 'ItemController@delete');

// Authentication

Route::get('login', 'Auth\LoginController@showLoginForm')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::get('logout', 'Auth\LoginController@logout')->name('logout');
Route::get('register', 'Auth\RegisterController@showRegistrationForm')->name('register');
Route::post('register', 'Auth\RegisterController@register');

Route::get('auctions', 'AuctionController@list')->name('auction');

//Footer

Route::get('about', 'FooterController@showAbout')->name('about');
Route::get('faq', 'FooterController@showFAQ')->name('faq');
Route::get('contact_us', 'FooterController@showContactUs')->name('contact_us');