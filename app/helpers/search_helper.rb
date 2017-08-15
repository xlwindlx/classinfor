module SearchHelper
  @@list = %w(red orange yellow olive green teal blue violet purple pink brown grey black)

  def ui_color(num)
    @@list[num.to_i % @@list.size]
  end

end
