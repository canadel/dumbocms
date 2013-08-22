function initialize() {
 
  var container = document.getElementById('gmap');
  var lat = container.getAttribute('data-latitude'); 
  var lng = container.getAttribute('data-longitude'); 
  var zoom = container.getAttribute('data-zoom'); 
  
  var mapOptions = {
    center: new google.maps.LatLng(lat, lng),
    zoom: +zoom,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  
  var map = new google.maps.Map(container, mapOptions);
}

google.maps.event.addDomListener(window, 'load', initialize);
