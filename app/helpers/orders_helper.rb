module OrdersHelper
  # These use the current date, but they could be lots easier.
  # Maybe just keep a global counter which starts at 10 or so.
  # That would be good enough if we only build 1 new record in the controller.
  #
  # And this of course is only needed because Ryan's example uses JS to add new
  # records. If you just build a new one in the controller this is all unnecessary.
  
  def add_order_detail_link(form)
    link_to_function image_tag("/images/add_button.s.png",:border=>0) do |page|
      order_detail = render(:partial => 'order_detail', :locals => { :pf => form, :order_detail => OrderDetail.new })
      page << %{
$('order_details').insert({ bottom: "#{ escape_javascript order_detail }".replace(/order\\[order_details_attributes\\]\\[\\d+\\]/g, "order[order_details_attributes]["+order_detail_count+"]").replace(/order_order_details_attributes_\\d+/g, "order_order_details_attributes_"+order_detail_count) });
order_detail_count++;
}
    end
  end
end
