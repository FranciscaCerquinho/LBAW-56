<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class WishList extends Model
{
    public $timestamps  = false;
    public $table='wishlist';
    protected $primaryKey = 'wishlist_id';

  /**
   * The auction owner
   */
  public function user() {
    return $this->belongsTo('App\User','id_user', 'id_auction');
  }

  /**
   * Return id auction
   */
  public function auction() {
    return  $this->belongsTo('App\Auction','id_auction', 'id_user');
  }

}
