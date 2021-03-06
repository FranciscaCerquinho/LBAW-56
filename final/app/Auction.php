<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Auction extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  public $table='auction';

  protected $primaryKey= 'auction_id';
    /**
    * The attributes that are mass assignable.
    *
    * @var array
    */
    protected $fillable = [
        'dateBegin','dateEnd', 'name', 'description','actualPrice','photo','buyNow','active','auction_like','auction_dislike'
    ];

    /**
    * The user this auction belongs to
    */
    public function owner() {
        return $this->belongsTo('App\Owner', 'id_auction', 'id_user');
    }


    /**
    * The auction comments
    */
    public function comments()
    {
        return $this->hasMany('App\Comment');
    }
}
