# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->
  # show info
  $('.subtitle > a').hover(
    ->  $(this).next().show(200)
        ,
    ->  $(this).next().hide(200)
  )


  # multiple selection for download

  $('.subtitle > a').click (event) ->
      return
      if event.ctrlKey or event.which is 2
        event.preventDefault()
      else
        return

      window.subs_to_download ||= []
      if $(this).data('selected?')
        $(this).data('selected?', false)
        to_remove_index = $.inArray(window.subs_to_download, {id: $(this).parent().attr('ltv_id'), name: $(this).parent().attr('ltv_name')})
        # remove sub id from array
        window.subs_to_download.splice(to_remove_index, 1)

        $(this).css('background-color', '')
        if window.subs_to_download.length is 0
          $('#download_bt').hide(200)
          $('#unselect_all').hide(200)
          $('#transparent_gradient_bottom').hide()
      else
        window.subs_to_download.push(
          {id: $(this).parent().attr('ltv_id'), name: $(this).parent().attr('ltv_name')}
        )
        $(this).css('background-color', '#dea')
        $(this).data('selected?', true)
        $('#transparent_gradient_bottom').show()
        $('#download_bt').show(200) if $('#download_bt').css('display') is 'none'
        $('#unselect_all').show(200) if $('#unselect_all').css('display') is 'none'



  # add subs_to_download in download_bt link parameter

  $('#download_bt').click ->
    new_download_bt_href = $(this).attr('href') + '?' + $.param({subs: window.subs_to_download})
    $(this).attr('href', new_download_bt_href)


  $('#unselect_all').click ->
    $('a').data('selected?', false)
    $('a').css('background-color', '')
    $(this).hide(200)
    $('#download_bt').hide(200)
    $('#transparent_gradient_bottom').hide()
    window.subs_to_download = null




