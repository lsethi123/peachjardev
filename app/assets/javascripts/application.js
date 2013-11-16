// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require bootstrap.min
//= require ajax
//= reuire admin
 $(document).ready(function ($) {
 	$(function() {
   $('#flash_notice').delay(500).fadeIn('normal', function() {
      $(this).delay(2500).fadeOut();
   });
});
$('#tabs').tab();
$('.icon-trash').on('click', function() { if(confirm("Are you sure?")){ 
	//alert($this);
	$(this).closest('tr').delay().fadeOut();
	$.get(this.href);
	} 
	return false;
});

$('#logout').on('click', function() { if(confirm("Are you sure?")){ 
	window.location.href 'https://www.dropbox.com/logout';
	
	return false;
});
$('#viewModal').on('hidden', function () {
  $(this).removeData('modal');
});

 // onlcik of previwe link
	$('.image_data').on('click', function () {
		//$('#viewModal .modal-body').html('<iframe src="'+$(this).data('href')+'" class="iframe_data">');
   		$('#viewModal .modal-body').html('<img alt="Loading" src="'+$(this).data('href')+'">');
   		//$('#viewModal').removeData();
	});
	$('.text_data').on('click', function () {
		url=$(this).data('href');
		//$.get($(this).data('href'),function(data,status,xhr){
		data_type=$(this).data('type');
		$('#viewModal').removeData();
		/*if (data_type=="application/octet-stream")
		{
			/*$.get($(this).data('href'),function(data,status,xhr){
				$('#viewModal .modal-body').html('<pre>'+data+'</pre>');
			})
			$('#viewModal .modal-body').html('<iframe src="'+url+'">');
		}
		else{
			//$('#viewModal .modal-body').html('<embed type="'+data_type+'" src="'+url+'">');
			$('#viewModal .modal-body').html('<iframe src="'+url+'">');
		}*/
		$('#viewModal .modal-body').html('<iframe src="'+url+'" class="iframe_data">');
		//data_type=xhr.getResponseHeader('Content-Type');
		//data_type="application/pdf";
		//alert(xhrgetResponseHeader('Content-Type'));
		//$('#viewModal .modal-body').html('<embed type="application/pdf" src="https://dl.dropboxusercontent.com/s/52hjropz0mwj1p1/learn-rails.pdf">');
		//$('#viewModal .modal-body').html('<embed type="'+data_type+'" src="'+url+'">');
		
		//$('#viewModal .modal-body').html('<pre>'+data+'</pre>');
		//})
	});
	
});

//  $(document).on("click", "#share_link", function () {
//     var file_name = $(this).data('file');
//     $('#share_link_form').html('<input type="hidden" name="file" value='+file_name +'/>');

// });
//  $('.modal-body').html('<%= escape_javascript(render :partial => 'sharelinkdetails', :object => @SL) %>');
// $('.modal-header').remove();