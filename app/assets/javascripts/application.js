//= require jquery
//= require jquery_ujs
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone/gandalf
//= require bootstrap
//= require_tree .

window.get_element = function(string) {
  
  console.log($(string));
  return $(string);
};