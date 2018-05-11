<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    public $timestamps  = false;
    public $table='category';
    

    protected $fillable = [
        'id_auction', 'category', 
    ];
}
