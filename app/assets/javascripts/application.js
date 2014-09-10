// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

$(function(){
  $('body').on('click', '.plus-btn', function(){
    var parent = $(this).parents('.row:first');
    var neww   = parent.clone()
    var random = Math.floor(Math.random()* 1000000);
    
    neww.find('input').each(function(){
      var that = this;
      $.each(['name', 'id'], function(i, v){
        $(that).prop(v, $(that).prop(v).replace(/[0-9]+/, random));
      });
      $(this).siblings('label').prop('for', $(this).prop('id'));
    }).val('');
    parent.after(neww);

    return false;
  });
});