$(document).ready ->
  $(".remove_search_term_buttom").hide()

  $(".search_term").hover(
    -> $(this).children().eq(1).show(100),
    -> $(this).children().eq(1).hide(50))

  $(".remove_search_term_buttom").click ->
    term = $('a[name="search_term_link"]', $(this).parent()).text()
    term = term.replace(/\s/g, "+") + "&"
    new_cookie_value = $.cookie('search_terms').replace(term, "")
    $.cookie('search_terms', new_cookie_value, { expires: 1000, path: '/' })

    $(this).parent().hide(150)
  



  
  